// ignore_for_file: non_constant_identifier_names, prefer_final_fields, must_be_immutable

import 'package:flutter/material.dart';

import '../../models/TasksModel.dart';
import '../../utils/App_constant.dart';
import 'firestorTodo.dart';

class EditScreen extends StatefulWidget {
  Tasksmodel _task;
  EditScreen(this._task, {super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController? title;
  TextEditingController? subtitle;

  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  int indexx = 0;
  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget._task.title);
    subtitle = TextEditingController(text: widget._task.subtitle);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.appMainColor.withOpacity(0.2),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            title_widget(),
            SizedBox(
              height: 20,
            ),
            subtitle_wdgit(),
            SizedBox(
              height: 20,
            ),
            imagess(),
            SizedBox(
              height: 20,
            ),
            button()
          ],
        ),
      ),
    );
  }

  Widget button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppConstant.appMainColor,
                minimumSize: Size(170, 48)),
            onPressed: () {
              if (title!.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Please Enter title!',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: AppConstant.appMainColor,
                  ),
                );
                return;
              }

              FireStore_Datasource().Update_task(
                  widget._task.id, indexx, title!.text, subtitle!.text);
              Navigator.pop(context);
            },
            child: Text(
              "Add Task",
              style: TextStyle(color: AppConstant.appTextColor),
            )),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 181, 0, 106),
                minimumSize: Size(170, 48)),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: AppConstant.appTextColor),
            )),
      ],
    );
  }

  Widget imagess() {
    return Container(
      height: 180,
      child: ListView.builder(
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                indexx = index;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      width: 2,
                      color: indexx == index
                          ? const Color.fromARGB(255, 61, 1, 71)
                          : const Color.fromARGB(255, 209, 42, 225)
                              .withOpacity(0.3))),
              width: 140,
              margin: EdgeInsets.all(8),
              child: Column(
                children: [
                  Image.asset(
                    "assests/images/${index}.png",
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget title_widget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: AppConstant.appTextColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          controller: title,
          focusNode: _focusNode1,
          style: TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              hintText: "title",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: const Color.fromARGB(255, 200, 157, 208),
                    width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: const Color.fromARGB(255, 239, 92, 253),
                      width: 2.0))),
        ),
      ),
    );
  }

  Padding subtitle_wdgit() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: AppConstant.appTextColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          maxLines: 3,
          controller: subtitle,
          focusNode: _focusNode2,
          style: TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            hintText: "subtitle",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: const Color.fromARGB(255, 200, 157, 208), width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: const Color.fromARGB(255, 239, 92, 253), width: 2.0),
            ),
          ),
        ),
      ),
    );
  }
}
