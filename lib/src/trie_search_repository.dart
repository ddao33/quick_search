import 'package:quick_search/quick_search.dart';
import 'package:quick_search/src/base_search_repository.dart';

class TrieNode<T> {
  Map<String, TrieNode<T>> children = {};
  Set<T> items = {};
}

/// A search repository that uses a Trie data structure to store and search items.
/// Parameters:
/// - [getSearchKeys]: A function that takes an item and returns a list of search keys.
/// - [allowSepcialCharacter]: Whether to allow special characters in the search keys.
class TrieSearchRepository<T> implements BaseSearchRepository<T> {
  final TrieNode<T> root = TrieNode<T>();

  final List<String> Function(T) getSearchKeys;
  final TextFormatter? textFormatter;
  TrieSearchRepository(
    List<T> items,
    this.getSearchKeys, {
    this.textFormatter,
  }) {
    addItems(items);
  }

  void addItems(List<T> items) {
    for (var item in items) {
      _addItem(item);
    }
  }

  void _addItem(T item) {
    for (var key in getSearchKeys(item)) {
      _insertItem(key, item);
    }
  }

  void _insertItem(String key, T item) {
    final formattedKey =
        textFormatter == null ? defaultTextFormatter(key) : textFormatter!(key);

    List<String> words = formattedKey.split(RegExp(r'\s+'));
    for (String word in words) {
      TrieNode<T> node = root;
      for (int i = 0; i < word.length; i++) {
        String char = word[i];
        node.children.putIfAbsent(char, () => TrieNode<T>());
        node = node.children[char]!;
      }
      node.items.add(item);
    }
  }

  @override
  Future<List<T>> search(String query) async {
    final formattedQuery = textFormatter == null
        ? defaultTextFormatter(query)
        : textFormatter!(query);
    List<String> words = formattedQuery.split(RegExp(r'\s+'));
    Set<T>? results;

    for (String word in words) {
      Set<T> wordResults = _searchWord(word);

      if (results == null) {
        results = wordResults;
      } else {
        results = results.intersection(wordResults);
      }

      if (results.isEmpty) break;
    }

    return results?.toList() ?? [];
  }

  Set<T> _searchWord(String word) {
    TrieNode<T> node = root;
    for (int i = 0; i < word.length; i++) {
      String char = word[i];
      if (!node.children.containsKey(char)) {
        return {};
      }
      node = node.children[char]!;
    }
    return _collectProducts(node);
  }

  Set<T> _collectProducts(TrieNode<T> node) {
    Set<T> results = Set.from(node.items);
    for (TrieNode<T> child in node.children.values) {
      results.addAll(_collectProducts(child));
    }
    return results;
  }
}
