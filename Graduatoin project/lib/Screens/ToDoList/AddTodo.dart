import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gp_2/utils/App_constant.dart';
import 'add_task.dart';
import 'streamBuilder.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  bool show = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.appTextColor,
      floatingActionButton: Visibility(
        visible: show,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddTask()),
            );
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
            } else if (notification.direction == ScrollDirection.reverse) {
              setState(() {
                show = false;
              });
            }
            return true;
          },
          child: ListView(
            padding: EdgeInsets.all(10),
            children: [
              Stream_task(false), // Active tasks
              SizedBox(height: 10),
              Center(
                child: Text(
                  "isDone",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Stream_task(true), // Completed tasks
            ],
          ),
        ),
      ),
    );
  }
}
