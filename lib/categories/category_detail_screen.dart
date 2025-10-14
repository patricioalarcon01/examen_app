import 'package:flutter/material.dart';
import '../models/category.dart';
import 'category_form_screen.dart';

class CategoryDetailScreen extends StatelessWidget {
  final Category category;
  const CategoryDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.name), actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => CategoryFormScreen(category: category)),
          ),
        )
      ]),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(category.name, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Estado: ${category.state}'),
          const SizedBox(height: 16),
          Text('ID: ${category.id}',
              style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
