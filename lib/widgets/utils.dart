import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  TextEditingController controller;
  String inputLabel;

  TextInput({Key? key, required this.controller, required this.inputLabel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: inputLabel,
        ),
      ),
    );
  }
}