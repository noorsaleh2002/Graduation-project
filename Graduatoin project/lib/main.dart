import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp_2/Screens/auth-ui/splash-screen.dart';

import 'Screens/auth-ui/sign-in-screen.dart';
import 'Screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SignInScreen(),
    );
  }
}
