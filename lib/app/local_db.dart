import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:sembast/sembast_io.dart';

class LocalDB {
  static get db async {
    final dir = await getApplicationDocumentsDirectory();
// make sure it exists
    await dir.create(recursive: true);
// build the database path
    final dbPath = join(dir.path, 'glow_up.db');
// open the database
    final db = await databaseFactoryIo.openDatabase(dbPath);
    return db;
  }
}
