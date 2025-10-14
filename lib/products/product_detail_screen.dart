import 'package:flutter/material.dart';
import '../models/product.dart';
import 'product_form_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name), actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProductFormScreen(product: product))),
        )
      ]),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (product.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(product.imageUrl,
                  height: 220, fit: BoxFit.cover),
            ),
          const SizedBox(height: 16),
          Text(product.name, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Precio: \$${product.price.toStringAsFixed(0)}'),
          Text('Estado: ${product.state}'),
          const SizedBox(height: 16),
          Text('ID: ${product.id}', style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
