// ignore_for_file: file_names, must_be_immutable, unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Componant/BackButton.dart';
import '../../Componant/MultiLineTextFormField.dart';
import '../../Componant/MyTextFormField.dart';
import '../../controllers/book-controller.dart';
import '../../controllers/pdf-controller.dart';
import '../../utils/App_constant.dart';

class AddFilePage extends StatelessWidget {
  FileController fileController = Get.put(FileController());

  AddFilePage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    PdfController pdfController = Get.put(PdfController());
    FileController fileController = Get.put(FileController());
    String userName = fileController.fAuth.currentUser?.displayName ?? "";
    String firstName = userName.split(' ').first; // Getting the first name
    return Scaffold(
      //drawer: DrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              color: AppConstant.appMainColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyBackbutton(),
                          Text("ADD NEW FILE",
                              style: TextStyle(
                                  color: AppConstant.appTextColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 70,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      InkWell(
                          onTap: () {
                            fileController.pickImage(context);
                          },
                          child: Obx(
                            () => Container(
                              height: 190,
                              width: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppConstant.appTextColor),
                              child: Center(
                                child: fileController.isImageUploading.value
                                    ? CircularProgressIndicator(
                                        color: AppConstant.appMainColor,
                                      )
                                    : fileController.imageUrl.value == ''
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Icon(
                                              Icons.add,
                                              color: AppConstant.appMainColor,
                                            ),
                                          )
                                        : Image.network(
                                            fileController.imageUrl.value,
                                            fit: BoxFit.cover,
                                          ),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Text("${firstName}",
                          style: TextStyle(
                            color: AppConstant.appTextColor,
                          )),
                      Text("Click To Add File ",
                          style: TextStyle(
                            color: AppConstant.appTextColor,
                          )),
                    ],
                  ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: fileController.pdfUrl.value == ''
                                    ? AppConstant.appMainColor
                                    : AppConstant.appTextColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: fileController.isPdfUploading.value
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: AppConstant.appTextColor,
                                    ),
                                  )
                                : fileController.pdfUrl.value == ""
                                    ? InkWell(
                                        onTap: () {
                                          fileController.pickPDF();
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.upload_file,
                                                color:
                                                    AppConstant.appTextColor),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "PDF FILE",
                                              style: TextStyle(
                                                  color:
                                                      AppConstant.appTextColor),
                                            ),
                                          ],
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          fileController.pdfUrl.value = '';
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.upload_file,
                                                color:
                                                    AppConstant.appTextColor),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Uploaded",
                                              style: TextStyle(
                                                  color:
                                                      AppConstant.appMainColor),
                                            ),
                                          ],
                                        ),
                                      ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MyTextFormField(
                    hintText: "Book title",
                    icon: Icons.book_rounded,
                    controller: fileController.title,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MultiLineTextFormField(
                    hintText: "Description",
                    controller: fileController.description,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MyTextFormField(
                      isNumber: true,
                      hintText: "Total Pages",
                      icon: Icons.numbers,
                      controller: fileController.pages),
                  SizedBox(
                    height: 10,
                  ),
                  MyTextFormField(
                      hintText: "Language",
                      icon: Icons.language,
                      controller: fileController.language),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Clear all input fields
                            fileController.title.clear();
                            fileController.description.clear();
                            fileController.pages.clear();
                            fileController.language.clear();
                            fileController.isPostUploading.value = false;
                            // Reset image and PDF selections
                            fileController.imageUrl.value = '';
                            fileController.pdfUrl.value = '';

                            // Navigate back
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 2, color: AppConstant.appMainColor)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.close,
                                    color: AppConstant.appMainColor),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "CANCLE",
                                  style: TextStyle(
                                      color: AppConstant.appMainColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Obx(
                        () => Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: AppConstant.appMainColor,
                              borderRadius: BorderRadius.circular(15)),
                          child: fileController.isPostUploading.value
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : InkWell(
                                  onTap: () {
                                    fileController.createFile();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.audio_file,
                                          color: AppConstant.appTextColor),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "POST",
                                        style: TextStyle(
                                            color: AppConstant.appTextColor),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      )),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
