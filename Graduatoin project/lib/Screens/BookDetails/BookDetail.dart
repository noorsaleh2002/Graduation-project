// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gp_2/Screens/BookDetails/BookActionButton.dart';
import 'package:gp_2/Screens/BookDetails/HeaderWidget.dart';
import 'package:gp_2/utils/App_constant.dart';

class BookDetails extends StatelessWidget {
  const BookDetails({super.key});

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
                  Expanded(child: BookDetailHeader()),
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
                        child: Text(
                            "some text some textsome text  textsome text textsome text textsome text textsome texttextsome texttextsome texttextsome texttextsome text textsome text some text some text some text",
                            style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontSize: 20)),
                      ),
                    ],
                  ),
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
                        child: Text(
                            "some text some textsome text  textsome text textsome text textsome text textsome texttextsome texttextsome texttextsome texttextsome text textsome text some text some text some text",
                            style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontSize: 20)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Bookactionbutton(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
