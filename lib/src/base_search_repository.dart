abstract class BaseSearchRepository<T> {
  Future<List<T>> search(String query);
}

String defaultTextFormatter(String text) {
  return text.toLowerCase().replaceAll(RegExp(r'[^\w]'), '');
}
