import 'package:flutter/material.dart';
import 'package:gp_2/utils/App_constant.dart';
import '../Screens/ToDoList/edit_screen.dart';
import '../Screens/ToDoList/firestorTodo.dart';
import '../models/TasksModel.dart';

class TaskWidget extends StatefulWidget {
  final Tasksmodel task;
  const TaskWidget(this.task, {super.key});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    bool isDone = widget.task.isDone;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        width: screenWidth * 0.9, // 90% of screen width
        height: screenHeight * 0.2, // 20% of screen height
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppConstant.appTextColor,
          boxShadow: [
            BoxShadow(
              color: AppConstant.appTextColor2.withOpacity(0.4),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              // Image
              imageWidget(screenHeight),

              const SizedBox(width: 15),

              // Task Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.task.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Checkbox(
                          value: isDone,
                          onChanged: (value) {
                            setState(() {
                              isDone = value!;
                            });
                            FireStore_Datasource()
                                .isdone(widget.task.id, isDone);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.task.subtitle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const Spacer(),

                    // Buttons
                    buttonRow(screenWidth),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageWidget(double screenHeight) {
    return Container(
      height: screenHeight * 0.15, // 15% of screen height
      width: screenHeight * 0.12, // Proportional width
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assests/images/${widget.task.image}.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buttonRow(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          buttonWidget(
            icon: Icons.watch_later_outlined,
            text: widget.task.time,
            width: screenWidth * 0.25, // 25% of screen width
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => EditScreen(widget.task)),
              );
            },
            child: buttonWidget(
              icon: Icons.edit,
              text: "Edit",
              width: screenWidth * 0.2, // 20% of screen width
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonWidget(
      {required IconData icon, required String text, required double width}) {
    return Container(
      width: width,
      height: 30,
      decoration: BoxDecoration(
        color: AppConstant.appMainColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppConstant.appTextColor),
            const SizedBox(width: 5),
            Text(
              text,
              style: TextStyle(
                color: AppConstant.appTextColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
