// ignore_for_file: file_names, avoid_print

import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../models/file-medel.dart';
import '../utils/App_constant.dart';

class FileController extends GetxController {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController pages = TextEditingController();
  TextEditingController aduioLen = TextEditingController();
  TextEditingController language = TextEditingController();
  ImagePicker imagePicker = ImagePicker();
  final storage = FirebaseStorage.instance;
  final db = FirebaseFirestore.instance;
  final fAuth = FirebaseAuth.instance;
  RxString imageUrl = ''.obs;
  RxString pdfUrl = ''.obs;
  int index = 0;
  RxBool isImageUploading = false.obs;
  RxBool isPdfUploading = false.obs;
  RxBool isPostUploading = false.obs; // true
  var fileData = RxList<FileModel>();
  var currentUserFiles = RxList<FileModel>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllFiles();
    getUserFile();
  }

  void getAllFiles() async {
    fileData.clear();
    Get.snackbar(
      'Success',
      "Get all Function",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppConstant.appMainColor,
      colorText: AppConstant.appTextColor,
    );
    var files = await db.collection('Files').get();
    for (var file in files.docs) {
      fileData.add(FileModel.fromJson(file.data()));
    }
  }

  void getUserFile() async {
    currentUserFiles.clear();
    var files = await db
        .collection('userFile')
        .doc(fAuth.currentUser!.uid)
        .collection('Files')
        .get();

    for (var file in files.docs) {
      currentUserFiles.add(FileModel.fromJson(file.data()));
    }
  }

  void pickImage() async {
    isImageUploading.value = true;
    final XFile? image = await imagePicker.pickImage(
        source: ImageSource.camera); // image.gallery
    if (image != null) {
      print(image.path);
      uploadImageToFirebase(File(image.path));
    }
  }

  void uploadImageToFirebase(File image) async {
    var uuid = Uuid();
    var filename = uuid.v1();
    var storageRef = storage.ref().child('Images/$filename');
    var response = await storageRef.putFile(image);
    String downloadURL = await storageRef.getDownloadURL();
    imageUrl.value = downloadURL;
    print('Download URL: $downloadURL');
    isImageUploading.value = false;
  }

  void createFile() async {
    isPostUploading.value = true;
    var newfile = FileModel(
      id: '$index',
      title: title.text,
      description: description.text,
      coverUrl: imageUrl.value,
      fileurl: pdfUrl.value,
      pages: int.parse(pages.text),
      language: language.text,
    );

    await db.collection('File').add(newfile.toJson());
    addFileInUserDb(newfile);
    //successMessage('File added to the db');
    isPostUploading.value = false;
    title.clear();
    description.clear();
    pages.clear();
    language.clear();
    aduioLen.clear();
    imageUrl.value = '';
    pdfUrl.value = '';
    Get.snackbar(
      'Success',
      "File added Successfully!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppConstant.appMainColor,
      colorText: AppConstant.appTextColor,
    );
    getAllFiles();
    getUserFile();
  }

  void pickPDF() async {
    isPdfUploading.value = true;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.first.path!);

      if (file.existsSync()) {
        Uint8List fileBytes = await file.readAsBytes();
        String fileName = result.files.first.name;
        print('File Bytes: $fileBytes');

        final response =
            await storage.ref().child("Pdf/$fileName").putData(fileBytes);

        final downloadURL = await response.ref.getDownloadURL();
        pdfUrl.value = downloadURL;
        print(downloadURL);
      } else {
        print('File does not exist');
      }
    } else {
      print('No file selectesd');
    }
    isPdfUploading.value = false;
  }

  void addFileInUserDb(FileModel file) async {
    await db
        .collection('userFile')
        .doc(fAuth.currentUser!.uid)
        .collection('Files')
        .add(file.toJson());
  }
}
