import 'package:flutter/material.dart';
import 'package:pmsn20232/database/agendadb.dart';
import 'package:pmsn20232/models/task_model.dart';
import 'package:pmsn20232/services/provider/tasks_provider.dart';
import 'package:pmsn20232/widgets/cards/card_task_widget.dart';
import 'package:pmsn20232/widgets/dropdown_widget.dart';
import 'package:pmsn20232/widgets/filter_text_widget.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class TaskScreen extends StatefulWidget {
  final String title;
  List<String> dropDownValues;
  TaskScreen({super.key, required this.title, required this.dropDownValues});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  AgendaDB? agendaDB;
  List<TaskModel>? selectedUserList = [];
  List<String>? selectedTaskList = [];
  List<String> dropDownValues = [];
  DropDownWidget? dropDownFilter;
  FilterTextWidget? filterText;

  @override
  void initState() {
    super.initState();
    agendaDB = AgendaDB();
    dropDownValues = widget.dropDownValues;
    dropDownFilter = DropDownWidget(controller: 'Todo', values: dropDownValues);
    filterText = FilterTextWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add')
                    .then((value) => {setState(() {})});
              },
              icon: const Icon(Icons.task))
        ],
      ),
      body: Stack(
        children: [filterText!, futureBuilder()],
      ), // children: [filtered(context)],
      floatingActionButton: FloatingActionButton(
        onPressed: () => openFilterDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void openFilterDialog(context) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Filter"),
              content: const Text("Choose option"),
              actions: [
                dropDownFilter!,
                ElevatedButton(
                  onPressed: () => setState(() {
                    Navigator.pop(context);
                  }),
                  child: const Text("OK"),
                )
              ],
            ));
  }

  FutureBuilder<List<TaskModel>> futureBuilder() {
    final updateTask = Provider.of<TaskProvider>(context);
    if (updateTask.isUpdated) {
      return filterDataGetting(updateTask);
    }
    return filterDataGetting(updateTask);
  }

  FutureBuilder<List<TaskModel>> filterDataGetting(TaskProvider updateTask) {
    switch (dropDownFilter!.controller) {
      case 'En proceso':
        return gettingByStatus(updateTask, 'E');
      case 'Completado':
        return gettingByStatus(updateTask, 'C');
      case 'Pendiente':
        return gettingByStatus(updateTask, 'P');
      default:
        return FutureBuilder(
            future: agendaDB!.GETALLTASK(),
            builder: (BuildContext context,
                AsyncSnapshot<List<TaskModel>> snapshot) {
              if (updateTask.isUpdated) {
                if (filterText!.filtered.isNotEmpty) {
                  return buildList(filterText!.filtered);
                } else {
                  return getList(snapshot);
                }
              } else {
                if (filterText!.filtered.isNotEmpty) {
                  return buildList(filterText!.filtered);
                } else {
                  return getList(snapshot);
                }
              }
            });
    }
  }

  FutureBuilder<List<TaskModel>> gettingByStatus(
      TaskProvider updateTask, String status) {
    return FutureBuilder(
        future: agendaDB!.getTaskByStatus(status),
        builder:
            (BuildContext context, AsyncSnapshot<List<TaskModel>> snapshot) {
          if (updateTask.isUpdated) {
            return getList(snapshot);
          } else {
            return getList(snapshot);
          }
        });
  }

  FutureBuilder<List<TaskModel>> gettingByText(
      TaskProvider updateTask, String nameTask) {
    return FutureBuilder(
        future: agendaDB!.getTaskByText(nameTask),
        builder:
            (BuildContext context, AsyncSnapshot<List<TaskModel>> snapshot) {
          if (updateTask.isUpdated) {
            return getList(snapshot);
          } else {
            return getList(snapshot);
          }
        });
  }

  Widget getList(snapshot) {
    if (snapshot.hasData) {
      return Container(
        margin: const EdgeInsets.fromLTRB(0, 120, 0, 0),
        child: ListView.builder(
            itemCount: snapshot.data!.length, //snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return CardTaskWidget(
                agendaDB!,
                taskModel: snapshot.data![index],
              );
            }),
      );
    } else {
      if (snapshot.hasError) {
        return const Center(
          child: Text('Error!'),
        );
      } else {
        return const CircularProgressIndicator();
      }
    }
  }

  Widget buildList(info) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 120, 0, 0),
      child: ListView.builder(
          itemCount: info!.length, //snapshot.data!.length,
          itemBuilder: (BuildContext context, int index) {
            return CardTaskWidget(
              agendaDB!,
              taskModel: info![index],
            );
          }),
    );
  }
}
