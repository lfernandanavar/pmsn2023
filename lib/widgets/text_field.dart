import 'package:flutter/material.dart';

class TxtTextField extends StatelessWidget {
  final TextInputType type;
  TxtTextField({super.key, this.placeholder = "Empty", required this.type});
  final String? placeholder;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.black,
      keyboardType: type,
      decoration: InputDecoration(
        label: Text(placeholder!),
        border: const OutlineInputBorder(),
      ),
      controller: controller,
    );
  }

  String get text => controller.text;

  set text(String value) {
    text = value;
  }
}
