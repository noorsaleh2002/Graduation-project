// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../Componant/BackButton.dart';
import '../../utils/App_constant.dart';

class FileDetailHeader extends StatelessWidget {
  final String coverUrl;
  final String title;
  final String description;
  final String pages;
  final String language;
  final String audioLen;

  const FileDetailHeader(
      {super.key,
      required this.coverUrl,
      required this.title,
      required this.description,
      required this.pages,
      required this.language,
      required this.audioLen});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyBackbutton(),
            Icon(
              Icons.favorite,
              color: AppConstant.appTextColor,
            )
          ],
        ),
        SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                coverUrl,
                width: 170,
              ),
            )
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          title,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppConstant.appTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        // Text(description, style: TextStyle(color: AppConstant.appTextColor),),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
              Text(
                'Pages',
                style: TextStyle(color: AppConstant.appTextColor),
              ),
              Text(
                pages,
                style: TextStyle(color: AppConstant.appTextColor),
              ),
            ]),
            Column(children: [
              Text(
                "Languages",
                style: TextStyle(color: AppConstant.appTextColor),
              ),
              Text(
                language,
                style: TextStyle(color: AppConstant.appTextColor),
              ),
            ]),
            Column(children: [
              Text(
                "audio",
                style: TextStyle(color: AppConstant.appTextColor),
              ),
              Text(
                audioLen,
                style: TextStyle(color: AppConstant.appTextColor),
              ),
            ]),
          ],
        ),
      ],
    );
  }
}
