import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_test/Utils/Helpers.dart';
import 'package:firebase_test/firebase/firebase_auth_controller.dart';
import 'package:firebase_test/models/note.dart';
import 'package:flutter/material.dart';

import '../../firebase/firebase_firestore_controller.dart';
import 'note_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> with Helpers {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'NOTES',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuthController().signOut();
              //A => B => C => D
              //A => B => F

              //A => B => C => D
              //F

              //home => Cart => Payment => Success
              //home => settings
              //pushNamedAndRemoveUntil(context, '/settings',(route) => route.settings.name == '/home);
              //pushNamedAndRemoveUntil(context, '/settings',(route) => false);

              // Navigator.pushNamedAndRemoveUntil(
              //     context, '/F', (route) => route.settings.name == '/B');

              Navigator.pushReplacementNamed(context, '/LoginScreen');
            },
            icon: const Icon(Icons.logout),
          ),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NoteScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.note_add)),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Note>>(
          stream: FirebaseFirestoreController().read(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        navigateToUpdateNoteScreen(snapshot, index);
                      },
                      leading: const Icon(Icons.note),
                      title: Text(snapshot.data!.docs[index].data().title),
                      subtitle: Text(snapshot.data!.docs[index].data().info),
                      trailing: IconButton(
                        onPressed: () async =>
                            await _deleteNote(snapshot.data!.docs[index].id),
                        icon: const Icon(Icons.delete),
                      ),
                    );
                  });
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.warning, size: 80),
                  Text(
                    'No data',
                    style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }

  Future<void> _deleteNote(String id) async {
    bool deleted = await FirebaseFirestoreController().delete(path: id);
    String message =
        deleted ? 'Note deleted successfully' : 'Note delete failed!';
    showSnackBar(context, massage: message, erorr: !deleted);
  }

  void navigateToUpdateNoteScreen(
      AsyncSnapshot<QuerySnapshot<Note>> snapshot, int index) {
    QueryDocumentSnapshot<Note> noteSnapshot = snapshot.data!.docs[index];
    Note note = noteSnapshot.data();
    note.id = noteSnapshot.id;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteScreen(note: note),
      ),
    );
  }
}
