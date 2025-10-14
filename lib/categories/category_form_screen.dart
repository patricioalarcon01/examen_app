import 'package:flutter/material.dart';
import '../repositories/category_repository.dart';
import '../models/category.dart';

class CategoryFormScreen extends StatefulWidget {
  final Category? category;
  const CategoryFormScreen({super.key, this.category});

  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final _repo = CategoryRepository();
  final _form = GlobalKey<FormState>();
  late final TextEditingController _name;
  late String _state;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.category?.name ?? '');
    _state = widget.category?.state ?? 'Activa';
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final c = Category(
      id: widget.category?.id ?? 0,
      name: _name.text.trim(),
      state: _state,
    );
    try {
      if (widget.category == null) {
        await _repo.add(c);
      } else {
        await _repo.edit(c);
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
    final isEdit = widget.category != null;
    return Scaffold(
      appBar:
          AppBar(title: Text(isEdit ? 'Editar categoría' : 'Nueva categoría')),
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
            DropdownButtonFormField<String>(
              initialValue: _state, // ← reemplaza value:
              items: const [
                DropdownMenuItem(value: 'Activa', child: Text('Activa')),
                DropdownMenuItem(value: 'Inactiva', child: Text('Inactiva')),
              ],
              onChanged: (v) => setState(() => _state = v ?? 'Activa'),
              decoration: const InputDecoration(labelText: 'Estado'),
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
