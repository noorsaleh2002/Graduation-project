// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gp_2/Componant/MyFiles.dart';
import 'package:gp_2/Screens/auth-ui/welcom-scren.dart';

import '../Componant/BookCard.dart';
import '../models/Data.dart';
import '../utils/App_constant.dart';
import '../widgets/SearchTextFild.dart';
import '../widgets/custom-drower-widget.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          AppConstant.appMainName,
          style: TextStyle(color: AppConstant.appTextColor),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () async {
              GoogleSignIn googleSignIn = GoogleSignIn();
              FirebaseAuth _auth = FirebaseAuth.instance;
              await _auth.signOut();
              await googleSignIn.signOut();
              Get.offAll(() => WelcomeScreen());
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.logout),
            ),
          )
        ],
      ),
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                color: AppConstant.appMainColor,
                height: Get.height / 5,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Text("Good morning ☀️🌼✨,",
                                  style: TextStyle(
                                    color: AppConstant.appTextColor,
                                  )),
                              Text("Noor",
                                  style: TextStyle(
                                    color: AppConstant.appTextColor,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Flexible(
                                  child: Text("Time to enhance your knowledge",
                                      style: TextStyle(
                                          color: AppConstant.appTextColor,
                                          fontSize: 11))),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SearchTextField(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("MY Files"),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    /*  GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: bookData.length,
                      itemBuilder: (context, index) {
                        return Bookcard(
                          coverUrl: bookData[index].coverUrl ??
                              "assests/images/book.jpeg",
                          title: bookData[index].title ?? "NO Title",
                          ontap: () {
                            print("Book ${bookData[index].title} clicked");
                          },
                        );
                      },
                    )*/
                    Column(
                        children: bookData
                            .map((e) => MyFiles(
                                title: e.title!,
                                coverUrl: e.coverUrl!,
                                author: e.author!,
                                price: e.price!,
                                rating: e.rating!,
                                totalRating: ""))
                            .toList())
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
