import 'dart:async';
import '../models/product.dart';
import '../services/api_client.dart';

class ProductRepository {
  final api = ApiClient.I;

  Future<List<Product>> list() async {
    final raw = await api.productList().timeout(const Duration(seconds: 15));
    return raw
        .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> add(Product p) async =>
      api.productAdd(p.toJson()).timeout(const Duration(seconds: 15));

  Future<void> edit(Product p) async =>
      api.productEdit(p.toJson()).timeout(const Duration(seconds: 15));

  Future<void> delete(int id) async =>
      api.productDelete(id).timeout(const Duration(seconds: 15));
}
