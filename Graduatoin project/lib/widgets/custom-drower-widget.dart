// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, no_leading_underscores_for_local_identifiers

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../ChatBot/chatbotScreen.dart';
import '../GeminiModelSummarizer/summaryScreen.dart';
import '../Screens/AddBook/AddNewBook.dart';
import '../Screens/Notes/NoteScreen.dart';
import '../Screens/ToDoList/AddTodo.dart';
import '../Screens/Translation/translationScreen.dart';
import '../Screens/auth-ui/welcom-scren.dart';
import '../Screens/main_screen.dart';
import '../Screens/setting/setting.dart';
import '../controllers/book-controller.dart';
import '../controllers/google-sign-in-controller.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  FileController fileController = Get.put(FileController());
  GoogleSignInController googleSignInController =
      Get.put(GoogleSignInController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Get.height / 25),
      child: Drawer(
        backgroundColor: Colors.purple[50],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular((20.0)),
          bottomRight: Radius.circular(20.0),
        )),
        child: Wrap(
          runSpacing: 10,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  title:
                      Text("${fileController.fAuth.currentUser!.displayName}"),
                  subtitle: Text(
                    '${fileController.fAuth.currentUser!.email}',
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      fileController.fAuth.currentUser?.photoURL ??
                          '', // Check if photoURL is available
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                            'assests/images/default_profile.png'); // Local image for email users
                      },
                    ),
                  )),
            ),
            Divider(
              indent: 10.0,
              endIndent: 10.0,
              thickness: 1.5,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text("Home"),
                leading: Icon(Icons.home),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Get.back();
                  Get.to(() => MainScreen());
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ListTile(
                onTap: () {
                  Get.back();
                  Get.to(() => AddFilePage());
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: Text("Add file"),
                leading: Icon(
                  Icons.file_copy,
                ),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ListTile(
                onTap: () {
                  Get.back();
                  Get.to(() => Summaryscreen());
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: Text("Summarize"),
                leading: Icon(Icons.summarize),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ListTile(
                onTap: () {
                  Get.back();
                  Get.to(() => TranslationScreen());
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: Text("Translation"),
                leading: Icon(Icons.translate),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ListTile(
                onTap: () {
                  Get.back();
                  Get.to(() => Chatbotscreen());
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: Text("ChatBot"),
                leading: Icon(Icons.chat),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  "Notes",
                ),
                leading: Icon(Icons.note_alt),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Get.back();
                  Get.to(() => NoteScreen());
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  "To Do List",
                ),
                leading: Icon(Icons.format_list_bulleted_add),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Get.back();
                  Get.to(() => AddTodoScreen());
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ListTile(
                onTap: () {
                  Get.back();
                  Get.to(() => SettingPage());
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: Text("settings"),
                leading: Icon(Icons.settings),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ListTile(
                onTap: () async {
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  FirebaseAuth _auth = FirebaseAuth.instance;
                  await _auth.signOut();
                  await googleSignIn.signOut();
                  Get.offAll(() => WelcomeScreen());
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: Text("Logout"),
                leading: Icon(Icons.logout),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
