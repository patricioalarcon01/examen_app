import 'dart:async';
import '../models/provider.dart';
import '../services/api_client.dart';

class ProviderRepository {
  final api = ApiClient.I;

  Future<List<ProviderModel>> list() async {
    final raw = await api.providerList().timeout(const Duration(seconds: 15));
    return raw
        .map((e) => ProviderModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> add(ProviderModel p) async =>
      api.providerAdd(p.toJson()).timeout(const Duration(seconds: 15));

  Future<void> edit(ProviderModel p) async =>
      api.providerEdit(p.toJson()).timeout(const Duration(seconds: 15));

  Future<void> delete(int id) async =>
      api.providerDelete(id).timeout(const Duration(seconds: 15));
}
