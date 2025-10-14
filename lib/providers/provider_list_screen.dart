import 'package:flutter/material.dart';
import '../repositories/provider_repository.dart';
import '../models/provider.dart';
import 'provider_detail_screen.dart';
import 'provider_form_screen.dart';

class ProviderListScreen extends StatefulWidget {
  const ProviderListScreen({super.key});

  @override
  State<ProviderListScreen> createState() => _ProviderListScreenState();
}

class _ProviderListScreenState extends State<ProviderListScreen> {
  final _repo = ProviderRepository();
  late Future<List<ProviderModel>> _future;

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

  Future<void> _delete(ProviderModel p) async {
    try {
      await _repo.delete(p.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Eliminado: ${p.name} ${p.lastName}')));
      _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proveedores')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final saved = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const ProviderFormScreen()),
          );
          if (saved == true) _reload();
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<ProviderModel>>(
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
                  const Text('No se pudo cargar proveedores'),
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
                const Text('Sin proveedores'),
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
                final p = items[i];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.store)),
                  title: Text('${p.name} ${p.lastName}'),
                  subtitle: Text('${p.mail} · ${p.state}'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProviderDetailScreen(provider: p)),
                  ),
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
                                    ProviderFormScreen(provider: p)),
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
