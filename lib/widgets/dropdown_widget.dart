import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DropDownWidget extends StatelessWidget {
  DropDownWidget({
    super.key,
    this.controller = "",
    this.values = const [""],
    this.labelText = "",
  });
  String labelText;
  String? controller;
  int? _id;
  List<String>? values;

  @override
  Widget build(BuildContext context) {
    if (values!.isNotEmpty) {
      _id = values!.length - 1;
    }
    return Container(
      padding: const EdgeInsets.all(8),
      child: DropdownButtonFormField<String>(
        value: controller,
        icon: const Icon(Icons.info),
        decoration: InputDecoration(
            prefixIcon: Container(
              margin: const EdgeInsets.only(left: 14, right: 14),
              child: const Icon(
                Icons.info,
              ),
            ),
            hintText: labelText,
            labelText: labelText),
        items: values!.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          controller = newValue;
          _id = values!.indexOf(newValue!);
        },
      ),
    );
  }

  int get id => _id!;

  set id(int value) {
    _id = value;
  }
}
