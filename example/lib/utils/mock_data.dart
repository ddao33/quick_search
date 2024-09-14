import 'package:example/data/product.dart';

Future<List<Product>> getProducts() async {
  return [
    Product(en: 'apple', pinyin: 'pingguo'),
    Product(en: 'green apple', pinyin: 'lvpingguo'),
  ];
}
