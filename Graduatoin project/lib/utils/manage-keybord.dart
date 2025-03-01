import 'package:flutter/material.dart';

class KeyboardUtil {
  static void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocuse = FocusScope.of(context);
    if (currentFocuse.hasPrimaryFocus) {
      currentFocuse.unfocus();
    }
  }
}
