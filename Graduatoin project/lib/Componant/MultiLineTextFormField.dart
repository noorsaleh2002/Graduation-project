import 'package:flutter/material.dart';

import '../utils/App_constant.dart';

class MultiLineTextFormField extends StatelessWidget {
  final String hintText;

  final TextEditingController controller;
  const MultiLineTextFormField(
      {super.key, required this.hintText, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 5,
      controller: controller,
      decoration: InputDecoration(
        fillColor: AppConstant.appTextColor2.withOpacity(0.2),
        filled: true,
        border: OutlineInputBorder(
            borderSide: BorderSide(color: AppConstant.appTextColor2)),
        hintText: hintText,
      ),
    );
  }
}
