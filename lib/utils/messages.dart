import 'package:flutter/material.dart';

class Messages {
  String okInsert = "Se ha insertado con éxito";
  String failInsert = "La inserción ha fallado";
  String okDelete = "Se ha eliminado con éxito";
  String failDelete = "No se ha podido eliminar";
  String okUpdate = "Se ha actualizado con éxito";
  String failUpdate = "La actualizació ha fallado";
  String somethingHappened = "Algo ha ocurrido...";
  String empty = "Se tienen que llenar todos los campos";

  int okColor = 0xFF84b6f4;
  int failColor = 0xFFFF6961;

  void okMessage(String message, BuildContext context) {
    var snackBar = SnackBar(
      elevation: 10,
      duration: const Duration(seconds: 2),
      content: Text(message),
      backgroundColor: Color(okColor),
      showCloseIcon: true,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void failMessage(String message, BuildContext context) {
    var snackBar = SnackBar(
      elevation: 10,
      duration: const Duration(seconds: 3),
      content: Text(message),
      backgroundColor: Color(failColor),
      showCloseIcon: true,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<dynamic> deleteMessageConfirm(
      BuildContext context, Function method, data) {
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
                onPressed: () {
                  method(data);
                  Navigator.pop(context);
                },
              )
            ]);
      },
    );
  }
}
