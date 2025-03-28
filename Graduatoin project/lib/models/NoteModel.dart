// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteModel {
  //get collection of notes

//final CollectionReference notes = FirebaseFirestore.instance.collection('Notes');
  final FirebaseFirestore notes = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create

  Future<void> addNote(String note) {
    return notes
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('Notes')
        .add({'note': note, 'timestamp': Timestamp.now()});
  }

  //read
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream = notes
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('Notes')
        .orderBy('timestamp', descending: true)
        .snapshots();
    return notesStream;
  }

  //update
  Future<void> updateNote(String docID, String newNote) {
    return notes
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('Notes')
        .doc(docID)
        .update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

  //delete
  Future<void> deleteNote(String docID) {
    return notes
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('Notes')
        .doc(docID)
        .delete();
  }
}
