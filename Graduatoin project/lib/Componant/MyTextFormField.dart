// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../utils/App_constant.dart';

class MyTextFormField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool isNumber;
  final TextEditingController controller;
  const MyTextFormField(
      {super.key,
      required this.hintText,
      required this.icon,
      required this.controller,
      this.isNumber = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        fillColor: AppConstant.appTextColor2.withOpacity(0.2),
        filled: true,
        border: OutlineInputBorder(
            borderSide: BorderSide(color: AppConstant.appTextColor2)),
        hintText: hintText,
        prefixIcon: Icon(
          icon,
          color: AppConstant.appTextColor2,
        ),
      ),
    );
  }
}
