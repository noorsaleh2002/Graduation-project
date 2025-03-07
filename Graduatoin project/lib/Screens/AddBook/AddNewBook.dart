import 'package:flutter/material.dart';
import 'package:gp_2/Componant/BackButton.dart';
import 'package:gp_2/Componant/MyTextFormField.dart';
import 'package:gp_2/utils/App_constant.dart';

import '../../Componant/MultiLineTextFormField.dart';

class AddBookPage extends StatelessWidget {
  const AddBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
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
                      Container(
                        height: 190,
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppConstant.appTextColor),
                        child: Icon(
                          Icons.add,
                          color: AppConstant.appMainColor,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Noor saleh ",
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
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: AppConstant.appMainColor,
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload_file,
                                  color: AppConstant.appTextColor),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "PDF FILE",
                                style:
                                    TextStyle(color: AppConstant.appTextColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: AppConstant.appMainColor,
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.audio_file,
                                  color: AppConstant.appTextColor),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "AUDIO FILE",
                                style:
                                    TextStyle(color: AppConstant.appTextColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MyTextFormField(
                      hintText: "Book title",
                      icon: Icons.book_rounded,
                      controller: controller),
                  SizedBox(
                    height: 10,
                  ),
                  MultiLineTextFormField(
                    hintText: "Description",
                    controller: controller,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MyTextFormField(
                      hintText: "Total Pages",
                      icon: Icons.numbers,
                      controller: controller),
                  SizedBox(
                    height: 10,
                  ),
                  MyTextFormField(
                      hintText: "Language",
                      icon: Icons.language,
                      controller: controller),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
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
                                style:
                                    TextStyle(color: AppConstant.appMainColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: AppConstant.appMainColor,
                              borderRadius: BorderRadius.circular(15)),
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
                                style:
                                    TextStyle(color: AppConstant.appTextColor),
                              ),
                            ],
                          ),
                        ),
                      ),
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
