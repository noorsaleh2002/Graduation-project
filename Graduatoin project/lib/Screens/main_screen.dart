import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart'; // To format the time

import '../Componant/FileCard.dart';
import '../controllers/book-controller.dart';
import '../utils/App_constant.dart';
import '../widgets/SearchTextFild.dart';
import '../widgets/custom-drower-widget.dart';
import 'AddBook/AddNewBook.dart';
import 'BookDetails/BookDetail.dart';
import 'auth-ui/welcom-scren.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FileController fileController = Get.put(FileController());

    // Get user's first name
    String userName = fileController.fAuth.currentUser?.displayName ?? "";
    String firstName = userName.split(' ').first; // Getting only the first name

    // Get current hour to determine greeting
    int currentHour = DateTime.now().hour;
    String greeting = currentHour >= 5 && currentHour < 12
        ? "Good morning ☀️🌼✨,"
        : (currentHour >= 12 && currentHour < 18
            ? "Good afternoon 🌞,"
            : "Good evening 🌙,");

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          AppConstant.appMainName,
          style: TextStyle(color: AppConstant.appTextColor),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: AppConstant.appTextColor),
            onPressed: () async {
              GoogleSignIn googleSignIn = GoogleSignIn();
              FirebaseAuth _auth = FirebaseAuth.instance;
              await _auth.signOut();
              await googleSignIn.signOut();
              Get.offAll(() => WelcomeScreen());
            },
          ),
        ],
      ),
      drawer: DrawerWidget(),
      body: RefreshIndicator(
        onRefresh: () async {
          await fileController.getUserFile();
        },
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Greeting Section
            Container(
              padding: EdgeInsets.all(10),
              color: AppConstant.appMainColor,
              height: Get.height / 4.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Text(greeting,
                          style: TextStyle(color: AppConstant.appTextColor)),
                      Text(firstName,
                          style: TextStyle(color: AppConstant.appTextColor)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Time to enhance your knowledge",
                    style: TextStyle(
                        color: AppConstant.appTextColor, fontSize: 11),
                  ),
                  SizedBox(height: 20),
                  Search(
                    onSearch: fileController.searchFiles,
                    onCancel: fileController.clearSearch,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Files:',
                    style: TextStyle(
                      color: AppConstant.appTextColor2,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Display User-Uploaded Files
                  Obx(() {
                    final filesToShow = fileController.searchResults.isNotEmpty
                        ? fileController.searchResults
                        : fileController.currentUserFiles;

                    if (fileController.searchResults.isEmpty &&
                        fileController.currentUserFiles.isNotEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'No files found with that title.',
                            style: TextStyle(
                                color: AppConstant.appMainColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                      );
                    }

                    if (filesToShow.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'No files uploaded yet.',
                            style: TextStyle(color: AppConstant.appTextColor),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filesToShow.length,
                      itemBuilder: (context, index) {
                        final file = filesToShow[index];
                        return FileCard(
                          title: file.title!,
                          coverUrl: file.coverUrl!,
                          ontap: () => Get.to(FileDetails(file: file)),
                        );
                      },
                    );
                  })
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddFilePage()); // Navigate to the AddFileScreen
        },
        backgroundColor: AppConstant.appMainColor,
        child: Icon(Icons.add, color: AppConstant.appTextColor),
      ),
    );
  }
}
