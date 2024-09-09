# Quick Search

A package allow you to create a search repository for quick search.

## Features

- Create custom search repositories
- Efficient searching using a Trie data structure
- Support for multiple search fields per item

## Usage

### Create your own search repository

```dart
import 'package:quick_search/quick_search.dart';

class Product {
  final String en;
  final String pinyin;

  Product({required this.en, required this.pinyin});
}

class ProductSearchRepository extends TrieSearchRepository<Product> {
  ProductSearchRepository(List<Product> products)
      : super(
          products,
          (product) => [
            product.en,
            product.pinyin,
          ],
        );
}
``` 

### Use the search repository

```dart

void main() async {
  final products = [
    Product(en: 'apple', pinyin: 'pingguo'),
    Product(en: 'banana', pinyin: 'xiangjiao'),
    Product(en: 'green apple', pinyin: 'lv pingguo'),
    Product(en: 'orange', pinyin: 'chengzi'),
  ];

  final searchRepository = ProductSearchRepository(products);
  final results = await searchRepository.search('app');

  results.forEach((product) => print(product.en));
  // Output:
  // apple
  // green apple
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.