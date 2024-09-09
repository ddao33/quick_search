abstract class BaseSearchRepository<T> {
  Future<List<T>> search(String query);
}
