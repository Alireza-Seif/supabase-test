import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.myTextFieldController,
    this.myTextFieldText,
    this.isPassword = false,
  });

  final TextEditingController myTextFieldController;
  final String? myTextFieldText;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: myTextFieldController,
      obscureText: isPassword,
      cursorColor: Colors.blue,
      decoration: InputDecoration(
        hintText: myTextFieldText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(7)),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(7)),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}
