import 'package:flutter/material.dart';
import 'package:pmsn20232/database/teacher_controller.dart';
import 'package:pmsn20232/models/teacher_model.dart';
import 'package:pmsn20232/services/provider/teacher_provider.dart';
import 'package:pmsn20232/widgets/cards/card_teacher_widget.dart';
import 'package:pmsn20232/widgets/filter_widget.dart';
import 'package:provider/provider.dart';

class TeacherScreen extends StatefulWidget {
  final String title;
  const TeacherScreen({super.key, required this.title});
  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  TeacherController? teacherController;
  FilterWidget? filterText;

  @override
  void initState() {
    super.initState();
    teacherController = TeacherController();
    filterText = FilterWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addTeacher')
                    .then((value) => {setState(() {})});
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: Stack(
        children: [
          filterText!,
          select(context),
        ],
      ), // children: [filtered(context)],
    );
  }

  FutureBuilder<List<TeacherModel>> select(context) {
    final provider = Provider.of<TeacherProvider>(context);
    if (provider.isUpdated) {
      return getList();
    }
    return getList();
  }

  FutureBuilder<List<TeacherModel>> getList() {
    return FutureBuilder(
        future: filterText!.txtController.text.isEmpty
            ? teacherController!.get()
            : teacherController!
                .getTeacherByName(filterText!.txtController.text),
        builder:
            (BuildContext context, AsyncSnapshot<List<TeacherModel>> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot.data);
          } else {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error!'),
              );
            } else {
              return const CircularProgressIndicator();
            }
          }
        });
  }

  Widget buildList(info) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 120, 0, 0),
      child: ListView.builder(
          itemCount: info!.length, //snapshot.data!.length,
          itemBuilder: (BuildContext context, int index) {
            return CardteacherWidget(
              teacherController!,
              teacherModel: info![index],
            );
          }),
    );
  }
}
