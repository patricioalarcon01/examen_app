import 'package:flutter/material.dart';
import '../repositories/provider_repository.dart';
import '../models/provider.dart';

class ProviderFormScreen extends StatefulWidget {
  final ProviderModel? provider;
  const ProviderFormScreen({super.key, this.provider});

  @override
  State<ProviderFormScreen> createState() => _ProviderFormScreenState();
}

class _ProviderFormScreenState extends State<ProviderFormScreen> {
  final _repo = ProviderRepository();
  final _form = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _lastName;
  late final TextEditingController _mail;
  late String _state;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.provider?.name ?? '');
    _lastName = TextEditingController(text: widget.provider?.lastName ?? '');
    _mail = TextEditingController(text: widget.provider?.mail ?? '');
    _state = widget.provider?.state ?? 'Activo';
  }

  @override
  void dispose() {
    _name.dispose();
    _lastName.dispose();
    _mail.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final p = ProviderModel(
      id: widget.provider?.id ?? 0,
      name: _name.text.trim(),
      lastName: _lastName.text.trim(),
      mail: _mail.text.trim(),
      state: _state,
    );
    try {
      if (widget.provider == null) {
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
    final isEdit = widget.provider != null;
    return Scaffold(
      appBar:
          AppBar(title: Text(isEdit ? 'Editar proveedor' : 'Nuevo proveedor')),
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
              controller: _lastName,
              decoration: const InputDecoration(labelText: 'Apellido'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _mail,
              decoration: const InputDecoration(labelText: 'Correo'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _state,
              items: const [
                DropdownMenuItem(value: 'Activo', child: Text('Activo')),
                DropdownMenuItem(value: 'Inactivo', child: Text('Inactivo')),
              ],
              onChanged: (v) => setState(() => _state = v ?? 'Activo'),
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
