import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/note_service.dart';
import 'note_add_screen.dart';
import 'note_edit_screen.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final NoteService _noteService = NoteService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder<List<Note>>(
        stream: _noteService.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final notes = snapshot.data;
          
          if (notes == null || notes.isEmpty) {
            return const Center(child: Text('No notes found. Add one!'));
          }

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return Dismissible(
                key: Key(note.id!),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _noteService.deleteNote(note.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${note.title} deleted')),
                  );
                },
                child: ListTile(
                  title: Text(note.title),
                  subtitle: Text(
                    note.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    '${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteEditScreen(note: note),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoteAddScreen()),
          );
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}
