// ignore_for_file: prefer_const_constructors, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gp_2/Screens/BookDetails/BookActionButton.dart';

import '../../models/file-medel.dart';
import '../../utils/App_constant.dart';
import 'HeaderWidget.dart';

class FileDetails extends StatelessWidget {
  final FileModel file;

  const FileDetails({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    // Handle potential null values safely
    String coverUrl = file.coverUrl ?? "";
    String title = file.title ?? "Unknown Title";
    String description = file.description ?? "No description available";
    String pages = file.pages?.toString() ?? "Unknown";
    String language = file.language ?? "Unknown";
    String fileId = file.id?.toString() ?? "Unknown";
    String fileUrl = file.fileurl ?? "";
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              color: AppConstant.appMainColor,
              child: Row(
                children: [
                  Expanded(
                    child: FileDetailHeader(
                      coverUrl: coverUrl,
                      title: title,
                      description: description,
                      pages: pages,
                      language: language,
                      fileId: fileId,
                      fileurl: fileUrl,
                      userId: user!.uid,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("About File",
                      style: TextStyle(
                          color: AppConstant.appTextColor2, fontSize: 30)),
                  SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(
                        color: AppConstant.appMainColor, fontSize: 20),
                  ),
                  SizedBox(height: 160),
                  if (fileUrl.isNotEmpty)
                    Fileactionbutton(
                      fileUrl: fileUrl,
                      title: title,
                    )
                  else
                    Text("No file URL available",
                        style: TextStyle(color: Colors.red, fontSize: 18)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
