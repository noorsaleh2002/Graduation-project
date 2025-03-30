// ignore_for_file: file_names, camel_case_types, prefer_final_fields, must_be_immutable

import 'package:flutter/material.dart';

import '../Screens/ToDoList/TaskDetail.dart';
import '../Screens/ToDoList/edit_screen.dart';
import '../Screens/ToDoList/firestorTodo.dart';
import '../models/TasksModel.dart';
import '../utils/App_constant.dart';

class Task_Widget extends StatefulWidget {
  Tasksmodel _task;
  Task_Widget(this._task, {super.key});

  @override
  State<Task_Widget> createState() => _Task_WidgetState();
}

class _Task_WidgetState extends State<Task_Widget> {
  @override
  Widget build(BuildContext context) {
    bool isDone = widget._task.isDone;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailScreen(task: widget._task),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppConstant.appTextColor,
            boxShadow: [
              BoxShadow(
                  color: AppConstant.appTextColor2.withOpacity(0.4),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 2))
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                imagee(),
                SizedBox(width: 25),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              widget._task.title,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Checkbox(
                            value: isDone,
                            onChanged: (value) {
                              setState(() {
                                isDone = !isDone;
                              });
                              FireStore_Datasource()
                                  .isdone(widget._task.id, isDone);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                        widget._task.subtitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade400,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 95,
                              height: 30,
                              decoration: BoxDecoration(
                                color:
                                    AppConstant.appMainColor.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                child: Row(
                                  children: [
                                    Icon(Icons.watch_later_outlined,
                                        color: AppConstant.appTextColor),
                                    SizedBox(width: 2),
                                    Text(
                                      widget._task.time,
                                      style: TextStyle(
                                        color: AppConstant.appTextColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        EditScreen(widget._task)));
                              },
                              child: Container(
                                width: 60,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: AppConstant.appMainColor
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(18)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Icon(Icons.edit,
                                          color: AppConstant.appTextColor),
                                      SizedBox(width: 2),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () async {
                                await FireStore_Datasource()
                                    .delete_task(widget._task.id);
                              },
                              child: Container(
                                width: 60,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: AppConstant.appMainColor
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(18)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Icon(Icons.delete,
                                          color: AppConstant.appTextColor),
                                      SizedBox(width: 2),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget imagee() {
    return Container(
      height: 130,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assests/images/${widget._task.image}.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
