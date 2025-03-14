import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_2/Screens/noteEditor.dart';
import 'package:gp_2/Screens/noteReader.dart';
import 'package:gp_2/utils/App_constant.dart';
import 'package:gp_2/widgets/notesCard.dart';

class Notesscreen extends StatefulWidget {
  const Notesscreen({super.key});

  @override
  State<Notesscreen> createState() => _NotesscreenState();
}

class _NotesscreenState extends State<Notesscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.appMainColor,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Notes",
          style: TextStyle(color: AppConstant.appTextColor),
        ),
        centerTitle: true,
        backgroundColor: AppConstant.appTextColor2,
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your recent Notes",
              style: GoogleFonts.roboto(
                  color: AppConstant.appTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("Notes").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  //cheaking the connection state, is we stilll load the data we can displaya a progress
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    return GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      children: snapshot.data!.docs
                          .map((note) => noteCard(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NoteReaderScreen(note),
                                    ));
                              }, note))
                          .toList(),
                    );
                  }
                  return Text(
                    "Ther's no Notes ",
                    style: GoogleFonts.nunito(color: AppConstant.appTextColor),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NoteEditorScreen()));
        },
        label: Text("Add Note"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
