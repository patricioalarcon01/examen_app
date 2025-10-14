import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryViewScreen extends StatelessWidget {
  final Category category;
  const CategoryViewScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Nombre: ${category.name}',
              style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text('Estado: ${category.state}'),
          const SizedBox(height: 16),
          Text('ID: ${category.id}'),
        ],
      ),
    );
  }
}
