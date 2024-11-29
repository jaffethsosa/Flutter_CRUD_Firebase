import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/service/firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen ({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //firestore
  final FirestoreService firestoreService = FirestoreService();

  // text controller
  final TextEditingController textController = TextEditingController();

  //open dialog box to add note 
  void openNoteBox( [String? docID]){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
      //text user input
      content: TextField(
        controller: textController,
      ),
      actions: [
        //button to saver
        ElevatedButton(
          onPressed: () {
            if (docID == null){
              firestoreService.addNote(textController.text);
            }

            else{
              firestoreService.updateNote(docID, textController.text);
            }

          if (textController.text.trim().isNotEmpty) {
      // saver note
          
          textController.clear();
          Navigator.pop(context);
        } else {
          // show a message if user input is empty
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter some text!')),
          );
        }
      },
  child: const Text("Add"),)
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes')),
        floatingActionButton: FloatingActionButton(
          onPressed: openNoteBox,
          child: const Icon(Icons.add)),
          body: StreamBuilder<QuerySnapshot>(
            stream: firestoreService.getNotesStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List noteList = snapshot.data!.docs;

                return ListView.builder( 
                  itemCount: noteList.length, 
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = noteList[index];
                    String docID = document.id;

                    Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                    String noteText = data['note'];

                    return ListTile(
                      title: Text(noteText),
                      trailing: IconButton(
                        onPressed: () => openNoteBox(docID),
                        icon: const Icon(Icons.settings),
                      ),
                    );
                  } ,
                );
              }
              //if there is not data retur
              else{
                return const Text("No notes yet..");
              }
            },
          ), 
        );
  }
}