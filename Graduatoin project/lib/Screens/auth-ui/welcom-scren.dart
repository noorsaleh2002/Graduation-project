// ignore: file_names
// ignore_for_file: avoid_unnecessary_containers, unused_field

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp_2/controllers/google-sign-in-controller.dart';
import 'package:lottie/lottie.dart';

import '../../utils/App_constant.dart';
import 'sign-in-screen.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final GoogleSignInController _googleSignInController =
      Get.put(GoogleSignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          "Welcome to study friend app",
          style: TextStyle(
            color: AppConstant.appTextColor,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Lottie.asset('assests/images/welcom.json'),
            ),
            Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Text(
                  "Happy Studing ",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: AppConstant.appTextColor2),
                )),
            SizedBox(
              height: Get.height / 12,
            ),
            Material(
              child: Container(
                width: Get.width / 1.2,
                height: Get.height / 12,
                decoration: BoxDecoration(
                  color: AppConstant.appMainColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextButton.icon(
                  icon: Image.asset(
                    'assests/images/google.jpeg',
                    width: Get.width / 12,
                    height: Get.height / 12,
                  ),
                  label: Text(
                    "Sign in with google",
                    style: TextStyle(color: AppConstant.appTextColor),
                  ),
                  onPressed: () {
                    _googleSignInController.signInWithGoogle();
                  },
                ),
              ),
            ),
            SizedBox(
              height: Get.height / 30,
            ),
            Material(
              child: Container(
                width: Get.width / 1.2,
                height: Get.height / 12,
                decoration: BoxDecoration(
                  color: AppConstant.appMainColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextButton.icon(
                  icon: Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Sign in with Email",
                    style: TextStyle(color: AppConstant.appTextColor),
                  ),
                  onPressed: () {
                    Get.to(() => SignInScreen());
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
