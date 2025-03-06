import 'package:flutter/material.dart';

import '../utils/App_constant.dart';

class Bookcard extends StatelessWidget {
  final String coverUrl;
  final String title;
  final VoidCallback ontap;
  const Bookcard(
      {super.key,
      required this.coverUrl,
      required this.title,
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: ontap,
        child: SizedBox(
          width: 120,
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: AppConstant.appMainColor,
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: Offset(2, 2))
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assests/images/book.jpeg',
                      //coverUrl
                      width: 120,
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              Text(
                "Title", //title
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
