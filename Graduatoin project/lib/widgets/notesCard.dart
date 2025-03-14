import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gp_2/utils/App_constant.dart';

Widget noteCard(Function()? onTap, QueryDocumentSnapshot doc) {
  return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: AppConstant.cardsColor[doc['color_id']],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(doc["note_title"], style: AppConstant.mainTitle),
            SizedBox(
              height: 4.0,
            ),
            Text(doc["creation_date"], style: AppConstant.dateTitle),
            SizedBox(
              height: 8.0,
            ),
            Text(
              doc["note_content"],
              style: AppConstant.mainContent,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ));
}
