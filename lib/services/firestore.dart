import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // get collection notes
  final CollectionReference notesCollection = FirebaseFirestore.instance
      .collection('notes');

  //Create a new note
  Future<void> createNote(String note) async {
    await notesCollection.add({'note': note, 'createdAt': Timestamp.now()});
  }

  // read all notes
  Stream<QuerySnapshot> getNotes() {
    final notes = notesCollection.orderBy('createdAt', descending: true);
    return notes.snapshots();
  }

  //Update note given a doc id
  Future<void> updateNote(String docId, String note) async {
    await notesCollection.doc(docId).update({
      'note': note,
      'updatedAt': Timestamp.now(),
    });
  }

  //Delete a note given a doc id
  Future<void> deleteNote(String docId) async {
    await notesCollection.doc(docId).delete();
  }
}
