import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_test/models/note.dart';

class FirebaseFirestoreController {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<bool> create({required Note note}) async {
    return await _fireStore
        .collection('notes')
        .add(note.toMap())
        .then((DocumentReference value) => true)
        .catchError((error) => false);
  }

  Future<bool> delete({required String path}) async {
    return _fireStore
        .collection('notes')
        .doc(path)
        .delete()
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> update({required Note note}) async {
    return _fireStore
        .collection('notes')
        .doc(note.id)
        .update(note.toMap())
        .then((value) => true)
        .catchError((error) => false);
  }

  Stream<QuerySnapshot<Note>> read() async* {
    Stream<QuerySnapshot<Note>> querySnapshot = _fireStore
        .collection('notes')
        .withConverter<Note>(
            fromFirestore: (snapshot, options) =>
                Note.fromMap(snapshot.data()!),
            toFirestore: (Note note, options) => note.toMap())
        .snapshots();
    yield* querySnapshot;
  }
}
