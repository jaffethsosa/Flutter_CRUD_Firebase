import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  //get coleccion of note
  final CollectionReference notes = 
  FirebaseFirestore.instance.collection('notes');

  //CREATE
  Future<void> addNote(String note) {
  return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
  });
}

  //READ
  Stream<QuerySnapshot>getNotesStream(){
    final notesStream = 
    notes.orderBy('timestamp', descending: true).snapshots();
    
    return notesStream;
  }
  //UPDATE
  Future<void> updateNote(String docID, String newNote) {
    return notes.doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }
  
  //DELETE

}