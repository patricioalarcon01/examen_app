import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductViewScreen extends StatelessWidget {
  final Product product;
  const ProductViewScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const ColoredBox(color: Colors.black12)),
          ),
          const SizedBox(height: 16),
          Text(product.name,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text('\$${product.price.toStringAsFixed(0)}'),
          const SizedBox(height: 8),
          Text('Estado: ${product.state}'),
          const SizedBox(height: 16),
          Text('ID: ${product.id}'),
        ],
      ),
    );
  }
}
