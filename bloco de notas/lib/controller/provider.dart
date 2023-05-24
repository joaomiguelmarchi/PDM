import 'package:flutter/material.dart';

import '../model/note.dart';
import 'CRUD.dart';

class ProviderNotes extends ChangeNotifier {
  ProviderNotes() {
    _init();
  }

  List<Note> _notes = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<Note> get notes => _notes;

  TextEditingController get nameController => _nameController;

  TextEditingController get noteController => _noteController;

  GlobalKey<FormState> get formKey => _formKey;

  set notes(value) {
    _notes = value;
    notifyListeners();
  }

  void _init() async {
    final db = CRUD();
    _notes = await db.findAll();

    notifyListeners();
  }

  void addNote(Note nota) {
    CRUD().save(nota);
    notifyListeners();
  }

  void updateNote(Note nota) {
    final db = CRUD();
    db.update(nota);
    notifyListeners();
  }

  void refresh() async {
    final db = CRUD();

    _notes.clear();

    _notes = await db.findAll();

    notifyListeners();
  }
  
  void removeNote(Note nota) async{
    final db = CRUD();
     await db.delete(nota.id ?? 0);
    notifyListeners();
  }
  
}
