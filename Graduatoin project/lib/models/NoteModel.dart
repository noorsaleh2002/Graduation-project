// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  //get collection of notes

  final CollectionReference notes =
      FirebaseFirestore.instance.collection('Notes');

  // create

  Future<void> addNote(String note) {
    return notes.add({'note': note, 'timestamp': Timestamp.now()});
  }

  //read
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream =
        notes.orderBy('timestamp', descending: true).snapshots();
    return notesStream;
  }

  //update
  Future<void> updateNote(String docID, String newNote) {
    return notes.doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

  //delete
  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }
}
