// ignore_for_file: file_names, unused_field, body_might_complete_normally_nullable, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../models/user-model.dart';
import '../utils/App_constant.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // For password visibility toggle
  var isPasswordVisible = false.obs;

  Future<UserCredential?> signUpMethod(String userName, String userEmail,
      String userPhone, String userCity, String userPassword,
      {String userDeviceToken = ''}) async {
    try {
      EasyLoading.show(status: "Creating account...");

      // Register user
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      User? user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-creation-failed',
          message: 'User creation failed. Please try again.',
        );
      }

      // Update user's display name
      await user.updateProfile(displayName: userName);
      await user.reload();

      // Send email verification
      await user.sendEmailVerification();

      // Create UserModel object
      UserModel userModel = UserModel(
        uId: user.uid,
        username: userName,
        email: userEmail,
        phone: userPhone,
        userImg: '',
        userDeviceToken: userDeviceToken,
        country: '',
        userAddress: '',
        street: '',
        isAdmin: false,
        isActive: true,
        createdOn: DateTime.now(),
        city: userCity,
      );

      // Save user data in Firestore
      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());

      EasyLoading.dismiss();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        "Sign-Up Failed",
        e.message ?? "An unknown error occurred",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstant.appMainColor,
        colorText: AppConstant.appTextColor,
      );
      return null;
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstant.appMainColor,
        colorText: AppConstant.appTextColor,
      );
      return null;
    }
  }
}
