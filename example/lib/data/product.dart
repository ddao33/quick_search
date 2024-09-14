class Product {
  final String en;
  final String pinyin;

  Product({required this.en, required this.pinyin});
}

Future<List<Product>> getProducts() async {
  return [
    Product(en: 'apple', pinyin: 'pingguo'),
    Product(en: 'green apple', pinyin: 'lvpingguo'),
    Product(en: 'banana', pinyin: 'xiangjiao'),
    Product(en: 'orange', pinyin: 'chengzi'),
    Product(en: 'red dragon fruit', pinyin: 'honghuolongguo'),
    Product(en: 'golden kiwi', pinyin: 'jin qiyiguo'),
    Product(en: 'honeydew melon', pinyin: 'mi gua'),
    Product(en: 'passion fruit', pinyin: 'bai xiang guo'),
    Product(en: 'blood orange', pinyin: 'xue cheng'),
    Product(en: 'star fruit', pinyin: 'yang tao'),
    Product(en: 'lemon lime', pinyin: 'ning meng qing kai'),
    Product(en: 'white peach', pinyin: 'bai tao'),
    Product(en: 'black grape', pinyin: 'hei putao'),
  ];
}
