// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unused_field, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import '../../controllers/sign-up-controller.dart';
import '../../utils/App_constant.dart';
import 'sign-in-screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpController _signUpController = Get.put(SignUpController());
  TextEditingController username = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPhone = TextEditingController();
  TextEditingController userCity = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstant.appMainColor,
          centerTitle: true,
          title: Text(
            "Sign Up",
            style: TextStyle(
              color: AppConstant.appTextColor,
            ),
          ),
          iconTheme: IconThemeData(color: AppConstant.appTextColor),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextFormField(
                  controller: username,
                  decoration: InputDecoration(labelText: "Username"),
                ),
                TextFormField(
                  controller: userEmail,
                  decoration: InputDecoration(labelText: "Email"),
                ),
                TextFormField(
                  controller: userPhone,
                  decoration: InputDecoration(labelText: "Phone"),
                ),
                TextFormField(
                  controller: userCity,
                  decoration: InputDecoration(labelText: "City"),
                ),
                TextFormField(
                  controller: userPassword,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Password"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String name = username.text.trim();
                    String email = userEmail.text.trim();
                    String password = userPassword.text.trim();
                    String city = userCity.text.trim();
                    String phone = userPhone.text.trim();

                    if (name.isEmpty || email.isEmpty || password.isEmpty) {
                      Get.snackbar("Error", "Please enter all details");
                    } else {
                      UserCredential? userCredential = await _signUpController
                          .signUpMethod(name, email, phone, city, password);

                      if (userCredential != null) {
                        Get.snackbar(
                            "Success", "Account created successfully!");
                        FirebaseAuth.instance.signOut();
                        Get.to(() => SignInScreen());
                      }
                    }
                  },
                  child: Text("SIGN UP"),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () => Get.to(() => SignInScreen()),
                  child: Text("Already have an account? Sign In"),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
