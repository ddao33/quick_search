import 'package:example/data/product.dart';
import 'package:quick_search/quick_search.dart';

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
