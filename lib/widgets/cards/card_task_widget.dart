import 'package:flutter/material.dart';
import 'package:pmsn20232/database/agendadb.dart';
import 'package:pmsn20232/models/task_model.dart';
import 'package:pmsn20232/services/provider/tasks_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CardTaskWidget extends StatelessWidget {
  AgendaDB agendaDB;
  TaskModel taskModel;
  CardTaskWidget(this.agendaDB, {super.key, required this.taskModel});
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(color: Colors.green),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            textDirection: TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Title: ${taskModel.nameTask!}'),
              const Padding(padding: EdgeInsets.all(2)),
              Text(
                  'Description: ${taskModel.dscTask!.length > 20 ? '${taskModel.dscTask!.substring(0, 20)}...' : taskModel.dscTask!.substring(0, taskModel.dscTask!.length)}'),
              const Padding(padding: EdgeInsets.all(2)),
              Text(taskModel.sttTask!.substring(0, 1)),
              Text("Fecha final: ${taskModel.endDate.toString()}"),
              Text("Recordatorio: ${taskModel.initDate.toString()}"),
            ],
          ),
          const Expanded(
            child: Text(''),
          ),
          Column(
            children: [
              IconButton(
                  onPressed: () {
                    if (taskModel.sttTask == 'C') {
                      taskModel.sttTask = 'P';
                    } else {
                      taskModel.sttTask = 'C';
                    }
                    agendaDB.updateStatusCompleted('tblTareas', {
                      'idTask': taskModel.idTask,
                      'nameTask': taskModel.nameTask,
                      'dscTask': taskModel.dscTask,
                      'sttTask': taskModel.sttTask,
                      'endDate': taskModel.endDate,
                      'initDate': taskModel.initDate,
                    }).then((value) {
                      final updateTask =
                          Provider.of<TaskProvider>(context, listen: false);
                      updateTask.isUpdated = true;
                      taskProvider.isUpdated = true;
                    });
                  },
                  icon: Icon(taskModel.sttTask == 'C'
                      ? Icons.star
                      : Icons.star_border)),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/add', arguments: taskModel);
                  },
                  icon: const Icon(Icons.edit)),
              IconButton(
                  onPressed: () {
                    deleteMessageConfirm(context, taskProvider);
                  },
                  icon: const Icon(Icons.delete))
            ],
          )
        ],
      ),
    );
  }

  Future<dynamic> deleteMessageConfirm(
      BuildContext context, TaskProvider taskProvider) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm to delete"),
          icon: const Icon(Icons.dangerous),
          content: const Text('Do you want delete task?'),
          alignment: Alignment.center,
          actions: [
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
                child: const Text('Confirm'),
                onPressed: () => agendaDB
                        .DELETE("tblTareas", taskModel.idTask!)
                        .then((value) {
                      final updateTask =
                          Provider.of<TaskProvider>(context, listen: false);
                      updateTask.isUpdated = true;
                      taskProvider.isUpdated = true;
                      Navigator.pop(context);
                    })),
          ],
        );
      },
    );
  }
}
