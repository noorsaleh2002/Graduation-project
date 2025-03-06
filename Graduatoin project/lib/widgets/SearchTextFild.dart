import 'package:flutter/material.dart';

import '../utils/App_constant.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key});

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
            width: 20,
          ),
          Icon(Icons.search),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  hintText: "Search here ...",
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
