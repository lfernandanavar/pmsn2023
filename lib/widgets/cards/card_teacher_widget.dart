import 'package:flutter/material.dart';
import 'package:pmsn20232/database/teacher_controller.dart';
import 'package:pmsn20232/models/teacher_model.dart';
import 'package:pmsn20232/services/provider/teacher_provider.dart';
import 'package:pmsn20232/utils/messages.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CardteacherWidget extends StatelessWidget {
  TeacherController teacherController;
  TeacherModel teacherModel;
  CardteacherWidget(this.teacherController,
      {super.key, required this.teacherModel});
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TeacherProvider>(context);
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
              Text(teacherModel.name!),
              Text(teacherModel.email!),
              const Padding(padding: EdgeInsets.all(2)),
            ],
          ),
          const Expanded(child: Text("")),
          IconButton(
            onPressed: () {
              Messages()
                  .deleteMessageConfirm(
                      context, teacherController.delete, teacherModel.idTeacher)
                  .then((value) {
                provider.isUpdated = !provider.isUpdated;
              });
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/addTeacher',
                  arguments: teacherModel);
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
    );
  }
}
