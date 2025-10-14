import 'package:flutter/material.dart';
import '../models/provider.dart';
import 'provider_form_screen.dart';

class ProviderDetailScreen extends StatelessWidget {
  final ProviderModel provider;
  const ProviderDetailScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('${provider.name} ${provider.lastName}'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProviderFormScreen(provider: provider)),
              ),
            )
          ]),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(title: const Text('Nombre'), subtitle: Text(provider.name)),
          ListTile(
              title: const Text('Apellido'), subtitle: Text(provider.lastName)),
          ListTile(title: const Text('Correo'), subtitle: Text(provider.mail)),
          ListTile(title: const Text('Estado'), subtitle: Text(provider.state)),
          const SizedBox(height: 16),
          Text('ID: ${provider.id}',
              style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
