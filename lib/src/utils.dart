abstract class DatabaseOperations {
  Future<void> put(String key, Map<String, dynamic> value);
  Future<List<Map<String, dynamic>>> getAll();

  /// Put multiple entries in the database in a single transaction.
  /// String is the key, Map<String, dynamic> is the value.
  Future<void> batchPut(List<MapEntry<String, Map<String, dynamic>>> entries);
}
