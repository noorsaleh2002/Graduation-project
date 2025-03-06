// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/App_constant.dart';

class MyBackbutton extends StatelessWidget {
  const MyBackbutton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.back();
      },
      child: Row(
        children: [
          Icon(
            Icons.arrow_back_ios_rounded,
            color: AppConstant.appTextColor,
          ),
          SizedBox(width: 5),
          Text(
            "Back",
            style: TextStyle(
              color: AppConstant.appTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
