import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note_model.dart';

class NoteService {
  final CollectionReference notesCollection = 
      FirebaseFirestore.instance.collection('notes');

  // Create a new note
  Future<void> addNote(Note note) async {
    await notesCollection.add(note.toMap());
  }

  // Read all notes
  Stream<List<Note>> getNotes() {
    return notesCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Note.fromMap(
          doc.data() as Map<String, dynamic>, 
          doc.id
        );
      }).toList();
    });
  }

  // Update a note
  Future<void> updateNote(Note note) async {
    await notesCollection.doc(note.id).update(note.toMap());
  }

  // Delete a note
  Future<void> deleteNote(String noteId) async {
    await notesCollection.doc(noteId).delete();
  }
}
