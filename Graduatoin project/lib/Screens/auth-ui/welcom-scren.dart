// ignore: file_names
import 'package:flutter/material.dart';
import 'package:gp_2/utils/App_constant.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          "Welcome to my app",
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
            )
          ],
        ),
      ),
    );
  }
}
