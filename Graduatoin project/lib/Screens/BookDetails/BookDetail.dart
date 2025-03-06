// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gp_2/utils/App_constant.dart';

import '../../Componant/BackButton.dart';

class BookDetails extends StatelessWidget {
  const BookDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 500,
            padding: EdgeInsets.all(20),
            color: AppConstant.appMainColor,
            child: Row(
              children: [
                Expanded(
                    child: Column(
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
                    Text("Data"),
                  ],
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
