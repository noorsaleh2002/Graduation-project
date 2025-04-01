// ignore_for_file: file_names, must_be_immutable, camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/taskWidget.dart';
import 'firestorTodo.dart';

class Stream_task extends StatelessWidget {
  bool done;
  final String emptyMessage;

  Stream_task(this.done, {super.key, this.emptyMessage = "No tasks available"});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FireStore_Datasource().stream(done),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final taskslist = FireStore_Datasource().getTasks(snapshot);

        if (taskslist.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                emptyMessage,
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: taskslist.length,
          itemBuilder: (context, index) {
            final task = taskslist[index];
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                FireStore_Datasource().delete_task(task.id);
              },
              child: Task_Widget(task),
            );
          },
        );
      },
    );
  }
}
