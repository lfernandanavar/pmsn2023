import 'package:flutter/material.dart';
import 'package:pmsn20232/database/career_controller.dart';
import 'package:pmsn20232/models/career_model.dart';
import 'package:pmsn20232/services/provider/career_provider.dart';
import 'package:pmsn20232/utils/messages.dart';
import 'package:provider/provider.dart';

class AddCareer extends StatefulWidget {
  const AddCareer({super.key});

  @override
  State<AddCareer> createState() => _AddCareerState();
}

class _AddCareerState extends State<AddCareer> {
  CareerModel? args;
  TextEditingController txtConName = TextEditingController();
  CareerController? careerController;

  @override
  void initState() {
    super.initState();
    careerController = CareerController();
  }

  void verifyIsEditting(data) {
    if (data == null) {
      args = null;
      return;
    }

    args = data as CareerModel;
    txtConName.text = args!.career!;
  }

  @override
  Widget build(BuildContext context) {
    final careerProvider = Provider.of<CareerProvider>(context);
    var data = ModalRoute.of(context)?.settings.arguments;
    if (data != null) {
      verifyIsEditting(data);
    }

    final txtNameTeacher = TextFormField(
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        label: Text('Career'),
        border: OutlineInputBorder(),
      ),
      controller: txtConName,
    );

    final ElevatedButton btnGuardar = ElevatedButton(
      onPressed: () {
        if (txtConName.text.isEmpty) {
          Messages().failMessage(Messages().empty, context);
          return;
        }
        args == null
            ? careerController!.insert({
                'career': txtConName.text,
              }).then((value) {
                if (value > 0) {
                  Messages().okMessage(Messages().okInsert, context);
                } else {
                  Messages().failMessage(Messages().failInsert, context);
                }
                careerProvider.isUpdated = !careerProvider.isUpdated;
                Navigator.pop(context);
              })
            : careerController!.update({
                'idCareer': args!.idCareer!,
                'career': txtConName.text,
              }).then((value) {
                if (value > 0) {
                  Messages().okMessage(Messages().okUpdate, context);
                } else {
                  Messages().failMessage(Messages().failUpdate, context);
                }
                careerProvider.isUpdated = !careerProvider.isUpdated;
                Navigator.pop(context);
              });
      },
      child: const Text('Save Career'),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("${args == null ? 'Add' : 'Update'} Career"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: txtNameTeacher),
            btnGuardar,
          ],
        ),
      ),
    );
  }
}
