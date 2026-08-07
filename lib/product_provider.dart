import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_service.dart';
import 'models.dart';

final productsProvider = FutureProvider<List<Product>>((ref) {
  return ref.read(apiServiceProvider).fetchProducts();
});

final categoriesProvider = FutureProvider<List<String>>((ref) {
  return ref.read(apiServiceProvider).fetchCategories();
});
