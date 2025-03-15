// ignore_for_file: unused_import, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:gp_2/Screens/ToDoList/streamBuilder.dart';

import '../../utils/App_constant.dart';
import 'add_task.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

bool show = true;

class _AddTodoScreenState extends State<AddTodoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: AppConstant.appTextColor),
          centerTitle: true,
          backgroundColor: AppConstant.appMainColor,
          title: Text(
            'To Do List',
            style: TextStyle(color: AppConstant.appTextColor),
          )),
      backgroundColor: AppConstant.appTextColor,
      floatingActionButton: Visibility(
        visible: show,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddTask()));
          },
          backgroundColor: AppConstant.appMainColor.withOpacity(0.6),
          child: Icon(
            Icons.add,
            color: AppConstant.appTextColor,
            size: 30,
          ),
        ),
      ),
      body: SafeArea(
          child: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.forward) {
            setState(() {
              show = true;
            });
          }

          if (notification.direction == ScrollDirection.reverse) {
            setState(() {
              show = false;
            });
          }
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stream_task(false),
              const SizedBox(height: 20),
              const Divider(
                color: AppConstant.appMainColor,
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
              Text(
                "isDone",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold),
              ),
              Stream_task(true),
            ],
          ),
        ),
      )),
    );
  }
}
