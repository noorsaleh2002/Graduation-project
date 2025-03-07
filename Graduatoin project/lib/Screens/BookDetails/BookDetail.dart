// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';

import '../../models/file-medel.dart';
import '../../utils/App_constant.dart';
import 'BookActionButton.dart';
import 'HeaderWidget.dart';

class FileDetails extends StatelessWidget {
  final FileModel file;

  const FileDetails({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              //height: 550,
              padding: EdgeInsets.all(20),
              color: AppConstant.appMainColor,
              child: Row(
                children: [
                  Expanded(
                      child: FileDetailHeader(
                    coverUrl: file.coverUrl!,
                    title: file.title!,
                    description: file.description!,
                    pages: file.pages.toString(),
                    language: file.language.toString(),
                    audioLen: '',
                  )),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("About File",
                          style: TextStyle(
                              color: AppConstant.appTextColor2, fontSize: 30)),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(file.description!,
                            style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontSize: 20)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 160,
                  ),
                  Fileactionbutton(
                    fileUrl: file.fileurl!,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
