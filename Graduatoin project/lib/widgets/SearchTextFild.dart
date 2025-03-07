// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../utils/App_constant.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstant.appTextColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Icon(Icons.search),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Search here ...',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
