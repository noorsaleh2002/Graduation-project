// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/App_constant.dart';
import '../BookPage/BookPage.dart';

class Fileactionbutton extends StatelessWidget {
  final String fileUrl;
  final String title;
  final String fileid;
  const Fileactionbutton(
      {super.key,
      required this.fileUrl,
      required this.title,
      required this.fileid});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
          color: AppConstant.appMainColor,
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Get.to(FilePage(
                fileUrl: fileUrl,
                title: title,
                fileid: fileid,
              ));
            },
            child: Row(
              children: [
                Icon(
                  Icons.my_library_books_sharp,
                  color: AppConstant.appTextColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text("READ BOOK",
                    style: TextStyle(
                        color: AppConstant.appTextColor, fontSize: 15))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
