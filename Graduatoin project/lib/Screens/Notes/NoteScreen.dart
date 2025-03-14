// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/NoteModel.dart';
import '../../utils/App_constant.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final NoteModel noteModel = NoteModel();
  final TextEditingController textController = TextEditingController();

  void openNoteBox({String? docID}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(controller: textController),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (docID == null) {
                        noteModel.addNote(textController.text);
                      } else {
                        noteModel.updateNote(docID, textController.text);
                      }
                      textController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('Add'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: AppConstant.appTextColor),
          centerTitle: true,
          backgroundColor: AppConstant.appMainColor,
          title: Text(
            'Notes',
            style: TextStyle(color: AppConstant.appTextColor),
          )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppConstant.appMainColor,
        elevation: 2,
        onPressed: openNoteBox,
        child: const Icon(Icons.add, color: AppConstant.appTextColor),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: noteModel.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: notesList.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot = notesList[index];
                  String docID = documentSnapshot.id;
                  Map<String, dynamic> data =
                      documentSnapshot.data() as Map<String, dynamic>;
                  String noteText = data['note'];
                  Timestamp timestamp =
                      data['timestamp']; // Extract the timestamp
                  String formattedTime = DateFormat('dd/MM/yyyy hh:mm a')
                      .format(timestamp.toDate());

                  return Card(
                      elevation: 4,
                      color: const Color.fromARGB(255, 245, 219, 250),
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  noteText,
                                  style: const TextStyle(
                                    color: AppConstant.appTextColor2,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      formattedTime, // Display the timestamp here
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          onPressed: () =>
                                              openNoteBox(docID: docID),
                                          icon: const Icon(Icons.edit,
                                              color: AppConstant.appMainColor)),
                                      IconButton(
                                          onPressed: () =>
                                              noteModel.deleteNote(docID),
                                          icon: const Icon(Icons.delete,
                                              color: AppConstant.appMainColor)),
                                    ],
                                  )
                                ],
                              ),
                            ]),
                      ));
                });
          } else {
            return const Center(child: Text('No notes..'));
          }
        },
      ),
    );
  }
}
