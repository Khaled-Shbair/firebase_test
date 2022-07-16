import 'package:firebase_test/Utils/Helpers.dart';
import 'package:firebase_test/firebase/firebase_firestore_controller.dart';
import 'package:flutter/material.dart';

import '../../models/note.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key, this.note}) : super(key: key);
  final Note? note;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> with Helpers {
  late TextEditingController _titleTextController;
  late TextEditingController _infoTextController;

  @override
  void initState() {
    super.initState();
    _titleTextController = TextEditingController(text: widget.note?.title);
    _infoTextController = TextEditingController(text: widget.note?.info);
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _infoTextController.dispose();
    super.dispose();
  }

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
          'NOTE',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsetsDirectional.all(20),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          TextField(
            controller: _titleTextController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: 'Title',
              prefixIcon: Icon(Icons.title),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black45,
                  width: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _infoTextController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: 'Info',
              prefixIcon: Icon(Icons.info),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black45,
                  width: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
              onPressed: () async => await _performSave(),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50)),
              child: const Text('Save')),
        ],
      ),
    );
  }

  Future<void> _performSave() async {
    if (_checkData()) {
      await _save();
    }
  }

  bool _checkData() {
    if (_titleTextController.text.isNotEmpty &&
        _infoTextController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(context, massage: 'Enter required data!', erorr: true);
    return false;
  }

  Future<void> _save() async {
    bool status = widget.note == null
        ? await FirebaseFirestoreController().create(note: note)
        : await FirebaseFirestoreController().update(note: note);
    String massage = status ? 'Note saved successfully' : 'Note save failed!';
    showSnackBar(context, massage: massage, erorr: !status);
    if (isNewNote()) {
      _clear();
    } else {
      Navigator.pop(context);
    }
  }

  void _clear() {
    _titleTextController.text = '';
    _infoTextController.text = '';
  }

  Note get note {
    Note note = isNewNote() ? Note() : widget.note!;
    note.title = _titleTextController.text;
    note.info = _infoTextController.text;
    return note;
  }

  bool isNewNote() => widget.note == null;
}
