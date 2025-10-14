import 'package:flutter/material.dart';
import '../models/provider.dart';

class ProviderViewScreen extends StatelessWidget {
  final ProviderModel provider;
  const ProviderViewScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${provider.name} ${provider.lastName}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Nombre: ${provider.name}'),
          Text('Apellido: ${provider.lastName}'),
          Text('Correo: ${provider.mail}'),
          const SizedBox(height: 12),
          Text('Estado: ${provider.state}'),
          const SizedBox(height: 16),
          Text('ID: ${provider.id}'),
        ],
      ),
    );
  }
}
