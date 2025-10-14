import 'package:flutter/material.dart';
import '../repositories/product_repository.dart';
import '../models/product.dart';
import 'product_detail_screen.dart';
import 'product_form_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _repo = ProductRepository();
  late Future<List<Product>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.list();
  }

  void _reload() {
    setState(() {
      _future = _repo.list();
    });
  }

  Widget _leadingFor(Product p) {
    if (p.imageUrl.isEmpty) {
      return const CircleAvatar(child: Icon(Icons.image_not_supported));
    }
    return CircleAvatar(
      backgroundImage: NetworkImage(p.imageUrl),
      onBackgroundImageError: (_, __) {},
    );
  }

  Future<void> _delete(Product p) async {
    try {
      await _repo.delete(p.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Eliminado: ${p.name}')));
      _reload(); // ✅ sin await
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final saved = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const ProductFormScreen()),
          );
          if (saved == true) _reload(); // ✅ sin await
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Product>>(
        future: _future,
        builder: (_, s) {
          if (s.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('No se pudo cargar productos'),
                    const SizedBox(height: 8),
                    Text('${s.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12)),
                    const SizedBox(height: 12),
                    FilledButton(
                        onPressed: _reload, child: const Text('Reintentar')),
                  ],
                ),
              ),
            );
          }
          final items = s.data ?? [];
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Sin productos'),
                  const SizedBox(height: 8),
                  FilledButton(
                      onPressed: _reload, child: const Text('Actualizar')),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final p = items[i];
                return ListTile(
                  leading: _leadingFor(p),
                  title: Text(p.name),
                  subtitle:
                      Text('\$${p.price.toStringAsFixed(0)} · ${p.state}'),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(product: p))),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final saved = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ProductFormScreen(product: p)),
                          );
                          if (saved == true) _reload();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _delete(p),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
