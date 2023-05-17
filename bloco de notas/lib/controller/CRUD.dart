import 'package:sqflite/sqflite.dart';

import '../model/note.dart';
import 'database_helper.dart';

class CRUD {
  static const String table = 'CREATE TABLE $_tablename('
      '$_id    INTEGER PRIMARY KEY AUTOINCREMENT,'
      '$_name  TEXT,'
      '$_note  TEXT);';

  static const String _tablename = 'NOTES';
  static const String _id = 'ID';
  static const String _name = 'NAME';
  static const String _note = 'NOTE';

  save(Note note) async {
    final Database bd = await getDatabase();

    return await bd.insert(
        _tablename,
        toMap(note),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
  }

  Map<String, dynamic> toMap(Note note) {
    final Map<String, dynamic> carMap = {};
    carMap[_id] = note.id;
    carMap[_name] = note.name;
    carMap[_note] = note.note;
    return carMap;
  }

  Future<List<Note>> findAll() async {
    final Database bd = await getDatabase();
    final List<Map<String, dynamic>> result = await bd.query(_tablename);
    return toList(result);
  }

  List<Note> toList(List<Map<String, dynamic>> listadenotas) {
    final List<Note> notes = [];
    for (Map<String, dynamic> row in listadenotas) {
      final Note notinha = Note(
        id: row[_id] ?? 0,
        name: row[_name] ?? '',
        note: row[_note] ?? '',
      );
      notes.add(notinha);
    }
    return notes;
  }

  Future<List<Note>> find(int id) async {
    final Database bd = await getDatabase();
    final List<Map<String, dynamic>> result = await bd.query(
      _tablename,
      where: '$_id = ?',
      whereArgs: [id],
    );
    return toList(result);
  }

  delete(int id) async {
    final Database bd = await getDatabase();
    return bd.delete(
      _tablename,
      where: '$_id = ?',
      whereArgs: [id],
    );
  }

}
