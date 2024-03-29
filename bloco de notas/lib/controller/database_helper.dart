import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'CRUD.dart';

Future<Database> getDatabase() async {
  final String path = join(
    await getDatabasesPath(),
    'app.db',
  );

  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(CRUD.table);
    },
    version: 1,
  );
}
