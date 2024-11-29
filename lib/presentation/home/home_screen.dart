import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/service/firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Firestore
  final FirestoreService firestoreService = FirestoreService();

  // Text controller
  final TextEditingController textController = TextEditingController();

  // Open dialog box to add note
  void openNoteBox([String? docID]) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // Text user input
        content: TextField(
          controller: textController,
        ),
        actions: [
          // Button to save
          ElevatedButton(
            onPressed: () {
              if (textController.text.trim().isNotEmpty) {
                if (docID == null) {
                  firestoreService.addNote(textController.text);
                } else {
                  firestoreService.updateNote(docID, textController.text);
                }
                textController.clear();
                Navigator.pop(context);
              } else {
                // Show a message if user input is empty
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter some text!')),
                );
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
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

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 5.0,
                  ),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(noteText),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Update button
                          IconButton(
                            onPressed: () => openNoteBox(docID),
                            icon: const Icon(Icons.settings),
                          ),
                          // Delete button
                          IconButton(
                            onPressed: () =>
                                firestoreService.deleteNote(docID),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            // If there is no data
            return const Center(
              child: Text("No notes yet..."),
            );
          }
        },
      ),
    );
  }
}
