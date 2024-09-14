import 'package:example/model/product.dart';
import 'package:example/repository/ngram_product_search_repository.dart';
import 'package:example/utils/db_utils.dart';
import 'package:flutter/material.dart';
import 'package:quick_search/quick_search.dart';
import 'package:sembast/sembast.dart';

class NgramSearchWidget extends StatefulWidget {
  const NgramSearchWidget({super.key});

  @override
  State<NgramSearchWidget> createState() => _NgramSearchWidgetState();
}

class _NgramSearchWidgetState extends State<NgramSearchWidget> {
  late Database db;
  List<Product> _searchResults = [];
  Map<String, Product> _products = {};
  late ProductNgramSearchRepository ngramProductSearchRepository;
  @override
  void initState() {
    super.initState();

    _setup();
  }

  void _setup() async {
    db = await initDatabase();
    final products = await getProducts();
    for (final p in products) {
      _products[p.en] = p;
    }
    // ngramProductSearchRepository = NgramProductSearchRepository(db: db, n: 2);
    ngramProductSearchRepository = ProductNgramSearchRepository(db: db);
    await ngramProductSearchRepository.addItems(
      products
          .map((e) => SearchItem(id: e.en, searchStrings: [e.en, e.pinyin]))
          .toList(),
    );
    print('Done Store ngrams');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
          ),
          onChanged: (value) async {
            final result = await ngramProductSearchRepository.search(value);
            final _r =
                result.map((e) => _products[e]).whereType<Product>().toList();
            setState(() {
              _searchResults = _r;
            });
          },
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final result = _searchResults[index];
              return ListTile(
                title: Text(result.en),
              );
            },
          ),
        ),
      ],
    );
  }
}
