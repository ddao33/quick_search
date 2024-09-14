// Updated abstract class for database operations
import 'package:quick_search/quick_search.dart';
import 'package:sembast/sembast.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

Future<Database> initDatabase() async {
  final appDocumentDir = await getApplicationDocumentsDirectory();
  final dbPath = join(appDocumentDir.path, 'ngrams3.db');
  DatabaseFactory dbFactory = databaseFactoryIo;
  Database db = await dbFactory.openDatabase(dbPath);
  return db;
}

// Updated Sembast implementation of DatabaseOperations
class SembastDatabaseOperations implements DatabaseOperations {
  final Database db;
  final StoreRef<String, Map<String, dynamic>> store =
      stringMapStoreFactory.store('ngram_search');

  SembastDatabaseOperations(this.db);

  @override
  Future<void> put(String key, Map<String, dynamic> value) async {
    await store.record(key).put(db, value);
  }

  @override
  Future<List<Map<String, dynamic>>> getAll() async {
    var snapshot = await store.find(db);
    return snapshot.map((record) => record.value).toList();
  }

  @override
  Future<void> batchPut(
      List<MapEntry<String, Map<String, dynamic>>> entries) async {
    final batch = db.transaction((txn) async {
      for (var entry in entries) {
        await store.record(entry.key).put(txn, entry.value);
      }
    });
    await batch;
  }
}
