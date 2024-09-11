import 'package:quick_search/src/utils.dart';

class SearchItem {
  final String id;
  final List<String> searchStrings;

  SearchItem({required this.id, required this.searchStrings});
}

class NgramSearchRepository {
  final DatabaseOperations dbOps;
  final int n;

  final Function(String text)? formatText;

  /// formatText is applied before n-gram generation.
  /// default is to convert to lowercase and remove special characters.
  NgramSearchRepository({
    required this.dbOps,
    this.n = 2,
    this.formatText,
  });

  Future<void> addItem({required SearchItem item}) async {
    Map<String, List<String>> ngramsMap = {};

    // Generate n-grams for each search string and store them in a map
    for (var searchString in item.searchStrings) {
      ngramsMap[searchString] =
          _generateNGrams(searchString, n, formatText: formatText);
    }

    await dbOps.put(item.id, {
      'id': item.id,
      'searchStrings': item.searchStrings,
      'ngramsMap': ngramsMap, // Map of search strings and their n-grams
    });
  }

  Future<void> addItems(
    List<SearchItem> items,
  ) async {
    List<MapEntry<String, Map<String, dynamic>>> batchEntries = [];

    for (var item in items) {
      String id = item.id;
      List<String> searchStrings = item.searchStrings;

      Map<String, List<String>> ngramsMap = {};

      for (var searchString in searchStrings) {
        ngramsMap[searchString] =
            _generateNGrams(searchString, n, formatText: formatText);
      }

      // Prepare the entry for batch operation
      batchEntries.add(MapEntry(id, {
        'id': id,
        'searchStrings': searchStrings,
        'ngramsMap': ngramsMap,
      }));
    }

    await dbOps.batchPut(batchEntries);
  }

  Future<List<String>> search(String query, {double threshold = 0.2}) async {
    List<String> queryNGrams =
        _generateNGrams(query, n, formatText: formatText);
    List<Map<String, dynamic>> matchingProducts = [];

    var snapshot = await dbOps.getAll();

    // Use parallel processing for better performance
    await Future.wait(snapshot.map((record) async {
      final id = record['id'];
      Map<String, List<Object?>> ngramsMap =
          Map<String, List<Object?>>.from(record['ngramsMap']);

      double highestSimilarity = 0;

      for (var targetNGrams in ngramsMap.values) {
        double similarity =
            _jaccardSimilarity(queryNGrams, targetNGrams.cast<String>());
        highestSimilarity =
            similarity > highestSimilarity ? similarity : highestSimilarity;
        if (highestSimilarity > threshold) {
          break;
        }
      }

      if (highestSimilarity > threshold) {
        matchingProducts.add({
          'id': id,
          'similarity': highestSimilarity,
        });
      }
    }));

    // Sort the result by similarity
    matchingProducts.sort((a, b) => b['similarity'].compareTo(a['similarity']));
    return matchingProducts.map((product) => product['id'] as String).toList();
  }
}

List<String> _generateNGrams(
  String text,
  int n, {
  Function(String text)? formatText,
}) {
  text = formatText != null
      ? formatText(text)
      : text.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');
  List<String> ngrams = [];
  for (int i = 0; i <= text.length - n; i++) {
    ngrams.add(text.substring(i, i + n));
  }
  return ngrams;
}

double _jaccardSimilarity(List<String> set1, List<String> set2) {
  var intersection = 0;
  var union = set1.length + set2.length;

  for (var item in set1) {
    if (set2.contains(item)) {
      intersection++;
      union--;
    }
  }

  return intersection / union;
}
