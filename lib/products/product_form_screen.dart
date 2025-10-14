import 'package:flutter/material.dart';
import '../repositories/product_repository.dart';
import '../models/product.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;
  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _repo = ProductRepository();
  final _form = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _price;
  late final TextEditingController _imageUrl;
  late String _state;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.product?.name ?? '');
    _price = TextEditingController(
      text: widget.product == null ? '' : _formatPrice(widget.product!.price),
    );
    _imageUrl = TextEditingController(text: widget.product?.imageUrl ?? '');

    final initialState = widget.product?.state;
    _state = (initialState != null && initialState.trim().isNotEmpty)
        ? initialState
        : 'Activo';
  }

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _imageUrl.dispose();
    super.dispose();
  }

  String _formatPrice(double value) {
    return (value % 1 == 0)
        ? value.toInt().toString()
        : value.toStringAsFixed(2);
  }

  double _parsePrice(String raw) {
    final cleaned = raw.replaceAll(',', '.').trim();
    return double.tryParse(cleaned) ?? 0;
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;

    final name = _name.text.trim();
    final price = _parsePrice(_price.text);
    final image = _imageUrl.text.trim();

    final p = Product(
      id: widget.product?.id ?? 0,
      name: name,
      price: price,
      imageUrl: image,
      state: _state,
    );

    try {
      if (widget.product == null) {
        await _repo.add(p);
      } else {
        await _repo.edit(p);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;
    return Scaffold(
      appBar:
          AppBar(title: Text(isEdit ? 'Editar producto' : 'Nuevo producto')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _price,
              decoration: const InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.number,
              validator: (v) {
                final value = _parsePrice(v ?? '');
                if (value <= 0) return 'Ingrese un precio válido';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _imageUrl,
              decoration:
                  const InputDecoration(labelText: 'URL imagen (opcional)'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _state,
              decoration: const InputDecoration(labelText: 'Estado'),
              items: const [
                DropdownMenuItem(value: 'Activo', child: Text('Activo')),
                DropdownMenuItem(value: 'Inactivo', child: Text('Inactivo')),
              ],
              onChanged: (v) => setState(() => _state = v ?? 'Activo'),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: Text(isEdit ? 'Guardar cambios' : 'Crear'),
            ),
          ],
        ),
      ),
    );
  }
}
