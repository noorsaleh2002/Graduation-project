import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppConstant {
  static String appMainName = 'Graduation Project';
  static String appPoweredBy = 'Powered By AN ';
  static const appMainColor = Color(0xFFCE93D8);
  static const appTextColor2 = Color.fromRGBO(212, 106, 230, 1);
  static const appTextColor = Color.fromARGB(255, 255, 255, 255);
  //Setting the cards diffrenet colors for notes screen

  static List<Color> cardsColor = [
    Colors.white,
    Colors.purple.shade100,
    Colors.red.shade100,
    Colors.orange.shade100,
    Colors.blue.shade100,
    Colors.green.shade100,
    Colors.yellow.shade100,
    Colors.pink.shade100,
    Colors.blueGrey.shade100,
  ];

  //setting the text style for notes screen

  static TextStyle mainTitle =
      GoogleFonts.roboto(fontSize: 18.0, fontWeight: FontWeight.bold);
  static TextStyle mainContent =
      GoogleFonts.nunito(fontSize: 16.0, fontWeight: FontWeight.normal);
  static TextStyle dateTitle =
      GoogleFonts.nunito(fontSize: 13.0, fontWeight: FontWeight.w500);
}
