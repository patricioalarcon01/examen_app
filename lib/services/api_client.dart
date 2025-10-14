import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Cliente REST con Basic Auth para la API
class ApiClient {
  ApiClient._();
  static final ApiClient I = ApiClient._();

  String host = '143.198.118.203:8100';
  String _user = 'test';
  String _pass = 'test2023';

  bool enableLogging = true;

  void setCredentials(String user, String pass) {
    _user = user.trim();
    _pass = pass.trim();
  }

  Map<String, String> get _authHeader {
    final b = base64Encode(utf8.encode('$_user:$_pass'));
    return {'authorization': 'Basic $b', 'content-type': 'application/json'};
  }

  Map<String, String> get _authHeaderClose => {
        ..._authHeader,
        'Connection': 'close',
      };

  Uri _http(String path) => Uri.http(host, path);

  void _check(http.Response r) {
    if (r.statusCode != 200) {
      throw HttpException('HTTP ${r.statusCode}: ${r.body}');
    }
    if (r.body.isEmpty) {
      throw const HttpException('Respuesta vacía del servidor');
    }
  }

  // ====== Helpers con cliente dedicado y reintentos (extra) ======

  Future<http.Response> _getWithClient(
    Uri uri, {
    required Map<String, String> headers,
    int attempts = 2,
    Duration timeout = const Duration(seconds: 12),
  }) async {
    Object? lastErr;
    for (var i = 0; i < attempts; i++) {
      final client = http.Client();
      try {
        final r = await client.get(uri, headers: headers).timeout(timeout);
        return r;
      } catch (e) {
        lastErr = e;
        await Future.delayed(const Duration(milliseconds: 200));
      } finally {
        client.close();
      }
    }
    // si agotó reintentos, relanza el último error
    if (lastErr != null) throw lastErr;
    throw const HttpException('Fallo desconocido en GET');
  }

  Future<http.Response> _postWithClient(
    Uri uri, {
    required Map<String, String> headers,
    Object? body,
    int attempts = 2,
    Duration timeout = const Duration(seconds: 12),
  }) async {
    Object? lastErr;
    for (var i = 0; i < attempts; i++) {
      final client = http.Client();
      try {
        final r = await client
            .post(uri, headers: headers, body: body)
            .timeout(timeout);
        return r;
      } catch (e) {
        lastErr = e;
        await Future.delayed(const Duration(milliseconds: 200));
      } finally {
        client.close();
      }
    }
    if (lastErr != null) throw lastErr;
    throw const HttpException('Fallo desconocido en POST');
  }

  // ====== Productos ======
  Future<List<dynamic>> productList() async {
    if (kDebugMode && enableLogging) {
      debugPrint('[ApiClient] GET /product_list_rest');
    }
    final r = await http
        .get(_http('ejemplos/product_list_rest/'), headers: _authHeader)
        .timeout(const Duration(seconds: 12));
    _check(r);
    final decoded = jsonDecode(r.body);
    if (decoded is Map && decoded['Listado'] is List) {
      return List<dynamic>.from(decoded['Listado']);
    }
    return decoded is List ? decoded : const [];
  }

  Future<void> productAdd(Map<String, dynamic> body) async {
    if (kDebugMode && enableLogging) {
      debugPrint('[ApiClient] POST /product_add_rest $body');
    }
    final r = await http
        .post(
          _http('ejemplos/product_add_rest/'),
          headers: _authHeader,
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 12));
    _check(r);
  }

  Future<void> productEdit(Map<String, dynamic> body) async {
    if (kDebugMode && enableLogging) {
      debugPrint('[ApiClient] POST /product_edit_rest $body');
    }
    final r = await http
        .post(
          _http('ejemplos/product_edit_rest/'),
          headers: _authHeader,
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 12));
    _check(r);
  }

  Future<void> productDelete(int id) async {
    if (kDebugMode && enableLogging) {
      debugPrint('[ApiClient] POST /product_del_rest id=$id');
    }
    final r = await http
        .post(
          _http('ejemplos/product_del_rest/'),
          headers: _authHeader,
          body: jsonEncode({'product_id': id}),
        )
        .timeout(const Duration(seconds: 12));
    _check(r);
  }

  // ====== Categorías ======
  Future<List<dynamic>> categoryList() async {
    if (kDebugMode && enableLogging) {
      debugPrint('[ApiClient] GET /category_list_rest');
    }
    final r = await http
        .get(_http('ejemplos/category_list_rest/'), headers: _authHeader)
        .timeout(const Duration(seconds: 12));
    _check(r);
    final decoded = jsonDecode(r.body);
    if (decoded is Map && decoded['Listado Categorias'] is List) {
      return List<dynamic>.from(decoded['Listado Categorias']);
    }
    return decoded is List ? decoded : const [];
  }

  Future<void> categoryAdd(Map<String, dynamic> body) async {
    if (kDebugMode && enableLogging) {
      debugPrint('[ApiClient] POST /category_add_rest $body');
    }
    final r = await http
        .post(
          _http('ejemplos/category_add_rest/'),
          headers: _authHeader,
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 12));
    _check(r);
  }

  Future<void> categoryEdit(Map<String, dynamic> body) async {
    if (kDebugMode && enableLogging) {
      debugPrint('[ApiClient] POST /category_edit_rest $body');
    }
    final r = await http
        .post(
          _http('ejemplos/category_edit_rest/'),
          headers: _authHeader,
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 12));
    _check(r);
  }

  Future<void> categoryDelete(int id) async {
    if (kDebugMode && enableLogging) {
      debugPrint('[ApiClient] POST /category_del_rest id=$id');
    }
    final r = await http
        .post(
          _http('ejemplos/category_del_rest/'),
          headers: _authHeader,
          body: jsonEncode({'category_id': id}),
        )
        .timeout(const Duration(seconds: 12));
    _check(r);
  }

  // ====== Proveedores (con reintento + client dedicado) ======
  Future<List<dynamic>> providerList() async {
    if (kDebugMode && enableLogging) {
      debugPrint('[ApiClient] GET /provider_list_rest (client+retry, close)');
    }
    final r = await _getWithClient(
      _http('ejemplos/provider_list_rest/'),
      headers: _authHeaderClose,
      attempts: 2, // 1 intento + 1 reintento
    );
    _check(r);
    final decoded = jsonDecode(r.body);
    if (decoded is Map && decoded['Proveedores Listado'] is List) {
      return List<dynamic>.from(decoded['Proveedores Listado']);
    }
    return decoded is List ? decoded : const [];
  }

  Future<void> providerAdd(Map<String, dynamic> body) async {
    if (kDebugMode && enableLogging) {
      debugPrint(
          '[ApiClient] POST /provider_add_rest (client+retry, close) $body');
    }
    final r = await _postWithClient(
      _http('ejemplos/provider_add_rest/'),
      headers: _authHeaderClose,
      body: jsonEncode(body),
      attempts: 2,
    );
    _check(r);
  }

  Future<void> providerEdit(Map<String, dynamic> body) async {
    if (kDebugMode && enableLogging) {
      debugPrint(
          '[ApiClient] POST /provider_edit_rest (client+retry, close) $body');
    }
    final r = await _postWithClient(
      _http('ejemplos/provider_edit_rest/'),
      headers: _authHeaderClose,
      body: jsonEncode(body),
      attempts: 2,
    );
    _check(r);
  }

  Future<void> providerDelete(int id) async {
    if (kDebugMode && enableLogging) {
      debugPrint(
          '[ApiClient] POST /provider_del_rest (client+retry, close) id=$id');
    }
    final r = await _postWithClient(
      _http('ejemplos/provider_del_rest/'),
      headers: _authHeaderClose,
      body: jsonEncode({'provider_id': id}),
      attempts: 2,
    );
    _check(r);
  }
}
