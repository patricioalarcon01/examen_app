import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../products/product_list_screen.dart';
import '../categories/category_list_screen.dart';
import '../providers/provider_list_screen.dart';
import '/screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _confirmAndLogout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Seguro que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );

    if (ok == true) {
      try {
        await AuthService.I.signOut();
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No se pudo cerrar sesión: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EXAMEN COMPUTACION MOVIL'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _confirmAndLogout(context);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Cerrar sesión'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Tile(
            icon: Icons.inventory_2_outlined,
            title: 'Productos',
            subtitle: 'Listar, ver, crear, editar, eliminar',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProductListScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _Tile(
            icon: Icons.category_outlined,
            title: 'Categorías',
            subtitle: 'Listar, ver, crear, editar, eliminar',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CategoryListScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _Tile(
            icon: Icons.store_outlined,
            title: 'Proveedores',
            subtitle: 'Listar, ver, crear, editar, eliminar',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProviderListScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _Tile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
