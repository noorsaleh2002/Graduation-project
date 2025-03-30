import 'package:flutter/material.dart';

import '../../models/TasksModel.dart';
import '../../utils/App_constant.dart';

class TaskDetailScreen extends StatelessWidget {
  final Tasksmodel task;

  TaskDetailScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppConstant.appTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${task.title}',
          style: TextStyle(color: AppConstant.appTextColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assests/images/${task.image}.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              SizedBox(height: 20),
              Text(
                task.title,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.appMainColor,
                ),
              ),
              SizedBox(height: 10),
              Text(
                task.subtitle,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.watch_later_outlined,
                      color: AppConstant.appMainColor),
                  SizedBox(width: 8),
                  Text(
                    task.time,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppConstant.appMainColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Text(
                    'Status: ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppConstant.appTextColor,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: task.isDone
                          ? AppConstant.appMainColor
                          : Colors.purple.shade500,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text(
                      task.isDone ? 'Completed' : 'Incomplete',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
