import 'package:flutter/material.dart';
import 'package:pmsn20232/services/local_storage.dart';

class CheckBoxWidget extends StatefulWidget {
  const CheckBoxWidget({super.key});

  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  bool isChecked = false;
  @override
  void initState() {
    if (LocalStorage.prefs.getBool('isActiveSession') != null) {
      LocalStorage.prefs.getBool('isActiveSession') as bool == true
          ? isChecked = true
          : isChecked = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: isChecked,
      onChanged: (value) {
        LocalStorage.prefs.setBool('isActiveSession', value!);
        isChecked = value;
        setState(() {
          
        });
      },
    );
  }
}
