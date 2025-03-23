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
  final String userId;
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
    required this.userId,
  });

  // Function to delete the file from Firebase
  Future<void> deleteFile(
      BuildContext context, String fileId, String userId) async {
    try {
      print(
          'Starting deletion process for fileId: $fileId and userId: $userId');

      // Reference to Firestore collections
      final firestore = FirebaseFirestore.instance;
      print('Firestore instance initialized.');

      // Query the 'File' collection to find the document with the matching 'id' field
      print('Querying Firestore for fileId: $fileId...');
      final querySnapshot = await firestore
          .collection('File')
          .where('id', isEqualTo: fileId)
          .limit(1)
          .get();

      // Check if the document exists
      if (querySnapshot.docs.isEmpty) {
        print('File document does not exist for fileId: $fileId');
        Get.snackbar(
          'Error',
          'File document does not exist.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Get the document
      final fileDoc = querySnapshot.docs.first;
      final fileDocRef = fileDoc.reference;
      print('File document found: ${fileDoc.id}');

      // Debugging: Print document data
      print('Document Data: ${fileDoc.data()}');

      // Retrieve coverUrl and bookUrl (with null safety)
      final coverUrl = fileDoc['coverUrl'] as String? ?? '';
      final bookUrl = fileDoc['bookUrl'] as String? ?? '';
      print('Cover URL: $coverUrl');
      print('Book URL: $bookUrl');

      // Delete the file document from the 'File' collection
      print('Deleting document from File collection...');
      await fileDocRef.delete();
      print('Document deleted from File collection.');

      // Delete the file document from the 'userFile' collection
      print('Querying userFile collection for fileId: $fileId...');
      final userFileDocRef = firestore
          .collection('userFile')
          .doc(userId)
          .collection('Files')
          .where('id', isEqualTo: fileId)
          .limit(1);
      final userFileQuerySnapshot = await userFileDocRef.get();

      if (userFileQuerySnapshot.docs.isNotEmpty) {
        print('Deleting document from userFile collection...');
        await userFileQuerySnapshot.docs.first.reference.delete();
        print('Document deleted from userFile collection.');
      } else {
        print('Document not found in userFile collection.');
      }

      // Delete the cover image from Firebase Storage (if applicable)
      if (coverUrl.isNotEmpty) {
        print('Deleting cover image from Firebase Storage...');
        final coverFileName = coverUrl.split('%2F').last.split('?').first;
        final storageRef =
            FirebaseStorage.instance.ref().child('Images/$coverFileName');
        await storageRef.delete();
        print('Cover image deleted: $coverFileName');
      } else {
        print('Cover URL is empty. Skipping cover image deletion.');
      }

      // Delete the PDF file from Firebase Storage (if applicable)
      if (bookUrl.isNotEmpty) {
        print('Deleting PDF file from Firebase Storage...');
        final pdfFileName = bookUrl.split('%2F').last.split('?').first;
        final storagePDF =
            FirebaseStorage.instance.ref().child('Pdf/$pdfFileName');
        await storagePDF.delete();
        print('PDF file deleted: $pdfFileName');
      } else {
        print('Book URL is empty. Skipping PDF file deletion.');
      }

      // Show a confirmation message using Get.snackbar
      Get.snackbar(
        'Success',
        'File deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      print('File deletion process completed successfully.');

      // Navigate back after deletion
      Navigator.pop(context);
    } catch (e) {
      // Handle errors
      print('Error during deletion: $e');
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
                await deleteFile(context, fileId, userId);
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
