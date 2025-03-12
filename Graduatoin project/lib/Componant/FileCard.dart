// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../utils/App_constant.dart';

class FileCard extends StatelessWidget {
  final String title;
  final String coverUrl;
  final VoidCallback ontap;

  const FileCard(
      {super.key,
      required this.title,
      required this.coverUrl,
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: ontap,
        child: Container(
          padding: EdgeInsets.all(10),
          // color: AppConstant.appTextColor2,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: AppConstant.appMainColor,
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(2, 2))
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                        // network
                        coverUrl,
                        width: 100,
                        fit: BoxFit.cover),
                  )),
              SizedBox(height: 10),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Title: $title ',
                      style: TextStyle(
                        color: AppConstant.appMainColor,
                      ),
                    ),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
