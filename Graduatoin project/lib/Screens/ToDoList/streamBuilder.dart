// ignore_for_file: file_names, must_be_immutable, camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widgets/taskWidget.dart';
import 'firestorTodo.dart';

class Stream_task extends StatelessWidget {
  bool done;
  Stream_task(this.done, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FireStore_Datasource().stream(done),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final taskslist = FireStore_Datasource().getTasks(snapshot);
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final task = taskslist[index];
              return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    FireStore_Datasource().delete_task(task.id);
                  },
                  child: TaskWidget(task));
            },
            itemCount: taskslist.length,
          );
        });
  }
}
