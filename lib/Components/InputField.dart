import 'package:flutter/material.dart';

import '../Constants.dart';

class InputField extends StatelessWidget {
  InputField(
      {@required this.controller,
      @required this.icon,
      @required this.hintText,
      @required this.validator,
      this.hideText = false,
      this.inputType});

  final TextEditingController controller;
  final Icon icon;
  final String hintText;
  final Function validator;
  final bool hideText;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: InputTextStyle,
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        prefixIcon: icon,
        fillColor: Colors.white24,
        filled: true,
        labelText: hintText,
        labelStyle: InputTextStyle.copyWith(color: Colors.grey),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      validator: validator,
      obscureText: hideText,
    );
  }
}
