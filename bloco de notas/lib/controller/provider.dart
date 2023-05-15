import 'package:flutter/material.dart';

import '../model/note.dart';
import 'CRUD.dart';

class ProviderNotes extends ChangeNotifier{
  ProviderNotes(){
    _init();
  }

  List<Note> _notes = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  List<Note> get notes => _notes;


  TextEditingController get nameController => _nameController;
  TextEditingController get noteController => _noteController;

  set notes(value) {
    _notes = value;
    notifyListeners();
  }


  void _init() async{
    _notes = await CRUD().findAll();

    notifyListeners();
  }

  void addNote(Note nota){
    CRUD().save(nota);
    notifyListeners();
  }

}