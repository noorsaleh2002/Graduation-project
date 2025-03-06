import 'package:flutter/material.dart';

import '../utils/App_constant.dart';

class MyFiles extends StatelessWidget {
  final String title;
  final String coverUrl;
  final String author;
  final int price;
  final String rating;
  final String totalRating;

  const MyFiles(
      {super.key,
      required this.title,
      required this.coverUrl,
      required this.author,
      required this.price,
      required this.rating,
      required this.totalRating});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: AppConstant.appMainColor,
              borderRadius: BorderRadius.circular(15)),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: const Color.fromARGB(255, 242, 210, 248),
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
                    width: 100,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 4,
                  ),
                  Text("Title"),
                  SizedBox(
                    height: 4,
                  ),
                  Text("Title"),
                  SizedBox(
                    height: 4,
                  ),
                  Text("Title"),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
