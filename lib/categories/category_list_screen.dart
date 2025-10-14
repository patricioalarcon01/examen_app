import 'package:flutter/material.dart';
import '../repositories/category_repository.dart';
import '../models/category.dart';
import 'category_detail_screen.dart';
import 'category_form_screen.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final _repo = CategoryRepository();
  late Future<List<Category>> _future;

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

  Future<void> _delete(Category c) async {
    try {
      await _repo.delete(c.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Eliminada: ${c.name}')));
      _reload(); //
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categorías')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final saved = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const CategoryFormScreen()),
          );
          if (saved == true) _reload();
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Category>>(
        future: _future,
        builder: (_, s) {
          if (s.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text('No se pudo cargar categorías'),
                  const SizedBox(height: 8),
                  Text('${s.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 12),
                  FilledButton(
                      onPressed: _reload, child: const Text('Reintentar')),
                ]),
              ),
            );
          }
          final items = s.data ?? [];
          if (items.isEmpty) {
            return Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('Sin categorías'),
                const SizedBox(height: 8),
                FilledButton(
                    onPressed: _reload, child: const Text('Actualizar')),
              ]),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final c = items[i];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.category)),
                  title: Text(c.name),
                  subtitle: Text(c.state),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CategoryDetailScreen(category: c))),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final saved = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    CategoryFormScreen(category: c)),
                          );
                          if (saved == true) _reload();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _delete(c),
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
