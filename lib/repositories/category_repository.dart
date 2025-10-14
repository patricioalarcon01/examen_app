import 'dart:async';
import '../models/category.dart';
import '../services/api_client.dart';

class CategoryRepository {
  final api = ApiClient.I;

  Future<List<Category>> list() async {
    final raw = await api.categoryList().timeout(const Duration(seconds: 15));
    return raw
        .map((e) => Category.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> add(Category c) async =>
      api.categoryAdd(c.toJson()).timeout(const Duration(seconds: 15));

  Future<void> edit(Category c) async =>
      api.categoryEdit(c.toJson()).timeout(const Duration(seconds: 15));

  Future<void> delete(int id) async =>
      api.categoryDelete(id).timeout(const Duration(seconds: 15));
}
