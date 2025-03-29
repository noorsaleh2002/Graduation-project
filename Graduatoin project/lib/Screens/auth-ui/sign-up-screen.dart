// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unused_field, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
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
            child: Column(
              children: [
                SizedBox(
                  height: Get.height / 20,
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: userEmail,
                        cursorColor: AppConstant.appMainColor,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.email,
                              color: AppConstant.appMainColor,
                            ),
                            contentPadding:
                                EdgeInsets.only(top: 2.0, left: 8.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color: AppConstant.appMainColor,
                                    width: 1.5)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color: AppConstant.appMainColor,
                                    width: 2.0))),
                      ),
                    )),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: username,
                        cursorColor: AppConstant.appMainColor,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            hintText: "UserName",
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.person,
                              color: AppConstant.appMainColor,
                            ),
                            contentPadding:
                                EdgeInsets.only(top: 2.0, left: 8.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color: AppConstant.appMainColor,
                                    width: 1.5)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color: AppConstant.appMainColor,
                                    width: 2.0))),
                      ),
                    )),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: userPhone,
                        cursorColor: AppConstant.appMainColor,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "Phone",
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.phone,
                              color: AppConstant.appMainColor,
                            ),
                            contentPadding:
                                EdgeInsets.only(top: 2.0, left: 8.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color: AppConstant.appMainColor,
                                    width: 1.5)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color: AppConstant.appMainColor,
                                    width: 2.0))),
                      ),
                    )),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    width: Get.width,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(
                          () => TextFormField(
                            controller: userPassword,
                            obscureText:
                                _signUpController.isPasswordVisible.value,
                            cursorColor: AppConstant.appMainColor,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey),
                                prefixIcon: Icon(
                                  Icons.password,
                                  color: AppConstant.appMainColor,
                                ),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      _signUpController.isPasswordVisible
                                          .toggle();
                                    },
                                    child: _signUpController
                                            .isPasswordVisible.value
                                        ? Icon(
                                            Icons.visibility_off,
                                            color: AppConstant.appMainColor,
                                          )
                                        : Icon(
                                            Icons.visibility,
                                            color: AppConstant.appMainColor,
                                          )),
                                contentPadding:
                                    EdgeInsets.only(top: 2.0, left: 8.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color: AppConstant.appMainColor,
                                        width: 1.5)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color: AppConstant.appMainColor,
                                        width: 2.0))),
                          ),
                        ))),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: userCity,
                        cursorColor: AppConstant.appMainColor,
                        keyboardType: TextInputType.streetAddress,
                        decoration: InputDecoration(
                            hintText: "City",
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.location_pin,
                              color: AppConstant.appMainColor,
                            ),
                            contentPadding:
                                EdgeInsets.only(top: 2.0, left: 8.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color: AppConstant.appMainColor,
                                    width: 1.5)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color: AppConstant.appMainColor,
                                    width: 2.0))),
                      ),
                    )),
                SizedBox(
                  height: Get.height / 20,
                ),
                Material(
                  child: Container(
                    width: Get.width / 2,
                    height: Get.height / 18,
                    decoration: BoxDecoration(
                      color: AppConstant.appMainColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextButton(
                      child: Text(
                        "SIGN UP",
                        style: TextStyle(color: AppConstant.appTextColor),
                      ),
                      onPressed: () async {
                        String name = username.text.trim();
                        String email = userEmail.text.trim();
                        String password = userPassword.text.trim();
                        String city = userCity.text.trim();
                        String phone = userPhone.text.trim();
                        String userDeviceToken = '';

                        if (name.isEmpty ||
                            email.isEmpty ||
                            phone.isEmpty ||
                            city.isEmpty ||
                            password.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "Please enter all details",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppConstant.appMainColor,
                            colorText: AppConstant.appTextColor,
                          );
                        } else {
                          UserCredential? userCredential =
                              await _signUpController.signUpMethod(
                            name,
                            email,
                            phone,
                            city,
                            password,
                            userDeviceToken,
                          );
                          if (userCredential != null) {
                            Get.snackbar(
                              "Verification email sent.",
                              "Please check your email.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppConstant.appMainColor,
                              colorText: AppConstant.appTextColor,
                            );

                            FirebaseAuth.instance.signOut();
                            Get.to(() => SignInScreen());
                          }
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height / 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: AppConstant.appMainColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.to(() => SignInScreen()),
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: AppConstant.appMainColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
