// ignore_for_file: file_names, unused_local_variable, no_leading_underscores_for_local_identifiers, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Componant/FileCard.dart';
import '../controllers/book-controller.dart';
import '../models/Data.dart';
import '../utils/App_constant.dart';
import '../widgets/SearchTextFild.dart';
import '../widgets/custom-drower-widget.dart';
import 'BookDetails/BookDetail.dart';
import 'auth-ui/welcom-scren.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FileController fileController = Get.put(FileController());
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          AppConstant.appMainName,
          style: TextStyle(
            color: AppConstant.appTextColor,
          ),
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
              child: Icon(
                Icons.logout,
                color: AppConstant.appTextColor,
              ),
            ),
          )
        ],
      ),
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              color: AppConstant.appMainColor,
              height: Get.height / 4.5,
              child: Expanded(
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
                              Text("Aya",
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
                                  child: Text(
                                      "Time to read file and enhance your knowledge",
                                      style: TextStyle(
                                          color: AppConstant.appTextColor,
                                          fontSize: 11))),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Search(),
                        ],
                      ),
                    ),
                  ],
                ),
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
                      Text(
                        'Your Files: ',
                        style: TextStyle(
                          color: AppConstant.appTextColor2,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  //obx
                  Column(
                    children: /* fileController.fileData*/ FileData.map(
                        (e) => FileCard(
                              title: e.title!,
                              coverUrl: e.coverUrl!,
                              ontap: () {
                                Get.to(FileDetails(
                                  file: e,
                                ));
                              },
                            )).toList(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
