import 'package:example/model/product.dart';
import 'package:flutter/material.dart';
import 'package:example/repository/product_search_repository.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late ProductSearchRepository productSearchRepository;

  List<Product> products = [];
  @override
  void initState() {
    super.initState();
    productSearchRepository = ProductSearchRepository([]);

    getProducts().then(
      (products) => productSearchRepository.addItems(
        products,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            hintText: 'Search',
          ),
          onChanged: (value) async {
            final result = await productSearchRepository.search(value);
            setState(() {
              products = result;
            });
          },
        ),
        Expanded(
          child: ListView.separated(
            itemCount: products.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(products[index].en),
                subtitle: Text(products[index].pinyin),
              );
            },
          ),
        ),
      ],
    );
  }
}
