import 'package:flutter/material.dart';
import '../services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _noteController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  // open dialog to add a new note
  void addNote() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add a new note'),
            content: TextField(
              controller: _noteController,
              decoration: const InputDecoration(hintText: 'Enter your note'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _firestoreService.createNote(_noteController.text);
                  _noteController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  // update note
  void updateNote(String docId, String note) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Update note'),
            content: TextField(
              controller: _noteController,
              decoration: const InputDecoration(hintText: 'Enter your note'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _firestoreService.updateNote(docId, _noteController.text);
                  _noteController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Update'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: StreamBuilder(
        stream: _firestoreService.getNotes(),
        builder: (context, snapshot) {
          // if the connection state is waiting, show a circular progress indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // if the snapshot has an error, show an error message
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching notes'));
          }
          // if the snapshot is empty, show a message
          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No notes found'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final note = snapshot.data!.docs[index];
              return ListTile(
                title: Text(note['note']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => updateNote(note.id, note['note']),
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () => _firestoreService.deleteNote(note.id),
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addNote(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
