// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../utils/App_constant.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.appMainColor,
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              child: Lottie.asset('assests/images/start.json'),
            )
          ],
        ),
      ),
    );
  }
}
