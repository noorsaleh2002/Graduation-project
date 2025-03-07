import 'package:flutter/material.dart';

import '../utils/App_constant.dart';

class MyTextFormField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  const MyTextFormField(
      {super.key,
      required this.hintText,
      required this.icon,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
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
