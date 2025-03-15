// ignore_for_file: file_names, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp_2/Screens/AdminMainScreen.dart';
import 'package:gp_2/Screens/auth-ui/welcom-scren.dart';
import 'package:gp_2/Screens/main_screen.dart';
import 'package:gp_2/controllers/get-user-data.dart';
import 'package:lottie/lottie.dart';

import '../../utils/App_constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      loggdin(context);
    });
  }

  Future<void> loggdin(BuildContext context) async {
    if (user != null) {
      final GetUserDataController getUserDataController =
          Get.put(GetUserDataController());
      var userData = await getUserDataController.getUserData(user!.uid);
      if (userData[0]['isAdmin'] == true) {
        Get.offAll(() => AdminMainScreen());
      } else {
        Get.offAll(() => MainScreen());
      }
    } else {
      Get.offAll(() => WelcomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppConstant.appMainColor,
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: Get.width,
                alignment: Alignment.center,
                child: Lottie.asset('assests/images/start.json'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              width: Get.width,
              alignment: Alignment.center,
              child: Text(
                AppConstant.appPoweredBy,
                style: TextStyle(
                    color: AppConstant.appTextColor,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
