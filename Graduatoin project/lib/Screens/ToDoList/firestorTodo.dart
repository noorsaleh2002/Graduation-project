// ignore_for_file: non_constant_identifier_names, avoid_print, camel_case_types, file_names, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:gp_2/models/TasksModel.dart';
import 'package:uuid/uuid.dart';

class FireStore_Datasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<bool> CreateUSer(String email) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set({"id": _auth.currentUser!.uid, "email": email});
      return true;
    } catch (e) {
      return true;
    }
  }

  Future<bool> AddNote(String subtitle, String title, int image) async {
    try {
      var uuid = Uuid().v4();
      DateTime date = DateTime.now();
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('tasks')
          .doc(uuid)
          .set({
        'id': uuid,
        'subtitle': subtitle,
        'isDone': false,
        'image': image,
        'time': '${date.hour}:${date.minute}',
        'title': title,
      });
      return true;
    } catch (e) {
      print("Error adding note: $e");
      return false;
    }
  }

  List getTasks(AsyncSnapshot snapshot) {
    try {
      final tasksList = snapshot.data.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        // Check if 'time' is a Timestamp or String
        final time = data['time'];
        String formattedTime;

        if (time is Timestamp) {
          formattedTime =
              time.toDate().toString(); // Convert Timestamp to String
        } else if (time is String) {
          formattedTime = time; // Already a String, use as is
        } else {
          formattedTime = 'Unknown Time'; // Handle null or unexpected cases
        }

        return Tasksmodel(data['id'], data['subtitle'], formattedTime,
            data['image'], data['title'], data['isDone']);
      }).toList();

      return tasksList;
    } catch (e) {
      print('Error fetching tasks: $e');
      return [];
    }
  }

  Stream<QuerySnapshot> stream(bool isDone) {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('tasks')
        .where('isDone', isEqualTo: isDone)
        .snapshots();
  }

  Future<bool> isdone(String uuid, bool isDon) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('tasks')
          .doc(uuid)
          .update({'isDone': isDon});
      return true;
    } catch (e) {
      print(e);
      return true;
    }
  }

  Future<bool> Update_task(
    String uuid,
    int image,
    String title,
    String subtitle,
  ) async {
    try {
      DateTime date = DateTime.now();

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('tasks')
          .doc(uuid)
          .update({
        'subtitle': subtitle,
        'title': title,
        'image': image,
        'time': '${date.hour}:${date.minute}'
      });
      return true;
    } catch (e) {
      print(e);
      return true;
    }
  }

  Future<bool> delete_task(String uuid) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('tasks')
          .doc(uuid)
          .delete();
      return true;
    } catch (e) {
      print(e);
      return true;
    }
  }
}
