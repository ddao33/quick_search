import 'package:example/utils/db_utils.dart';
import 'package:quick_search/quick_search.dart';
import 'package:sembast/sembast.dart';

class ProductNgramSearchRepository extends NgramSearchRepository {
  ProductNgramSearchRepository({required Database db})
      : super(dbOps: SembastDatabaseOperations(db), n: 2);
}
