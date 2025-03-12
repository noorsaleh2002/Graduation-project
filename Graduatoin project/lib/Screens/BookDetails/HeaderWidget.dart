import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX
import '../../Componant/BackButton.dart';
import '../../utils/App_constant.dart';

class FileDetailHeader extends StatelessWidget {
  final String coverUrl;
  final String title;
  final String description;
  final String pages;
  final String language;
  final String audioLen;
  final String fileId; // File document ID in Firestore
  final String fileurl;

  const FileDetailHeader({
    super.key,
    required this.coverUrl,
    required this.title,
    required this.description,
    required this.pages,
    required this.language,
    required this.audioLen,
    required this.fileId,
    required this.fileurl,
  });

  // Function to delete the file from Firebase
  Future<void> deleteFile(BuildContext context) async {
    try {
      // Delete the file document from Firestore (adjust collection name if needed)
      await FirebaseFirestore.instance.collection('File').doc(fileId).delete();

      // Delete the cover image from Firebase Storage (if applicable)
      if (coverUrl.isNotEmpty) {
        final storageRef = FirebaseStorage.instance.refFromURL(coverUrl);
        await storageRef.delete();
      }

      // Delete the PDF file from Firebase Storage (if applicable)
      if (fileurl.isNotEmpty) {
        final storagePDF = FirebaseStorage.instance.refFromURL(fileurl);
        await storagePDF.delete();
      }

      // Show a confirmation message using Get.snackbar
      Get.snackbar(
        'Success',
        'File deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate back after deletion
      Navigator.pop(context);
    } catch (e) {
      // Handle errors
      Get.snackbar(
        'Error',
        'Failed to delete file: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyBackbutton(),
            IconButton(
              onPressed: () async {
                await deleteFile(context);
              },
              icon: Icon(
                Icons.delete,
                color: AppConstant.appTextColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                coverUrl,
                width: 170,
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Text(
          title,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppConstant.appTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  'Pages',
                  style: TextStyle(color: AppConstant.appTextColor),
                ),
                Text(
                  pages,
                  style: TextStyle(color: AppConstant.appTextColor),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  "Languages",
                  style: TextStyle(color: AppConstant.appTextColor),
                ),
                Text(
                  language,
                  style: TextStyle(color: AppConstant.appTextColor),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  "Audio",
                  style: TextStyle(color: AppConstant.appTextColor),
                ),
                audioLen.isEmpty
                    ? Text(
                        "No Audio for this file",
                        style: TextStyle(
                          color: AppConstant.appTextColor,
                          fontSize: 12,
                        ),
                      )
                    : Text(
                        audioLen,
                        style: TextStyle(color: AppConstant.appTextColor),
                      ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
