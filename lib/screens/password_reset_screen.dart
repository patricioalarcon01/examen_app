import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _busy = false;
  bool _loaderShown = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _showLoader(String message) {
    if (!mounted || _loaderShown) return;
    _loaderShown = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => Dialog(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              SizedBox(width: 16),
              Text('Enviando correo...'),
            ],
          ),
        ),
      ),
    );
  }

  void _closeLoader() {
    if (!mounted || !_loaderShown) return;
    _loaderShown = false;
    final rootNav = Navigator.of(context, rootNavigator: true);
    if (rootNav.canPop()) rootNav.pop();
  }

  Future<void> _sendResetEmail() async {
    if (_busy) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _busy = true);
    _showLoader('Enviando correo...');

    final messenger = ScaffoldMessenger.of(context);

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim())
          .timeout(const Duration(seconds: 12));

      if (!mounted) return;
      _closeLoader();

      messenger.showSnackBar(
        const SnackBar(content: Text('Correo de recuperación enviado.')),
      );

      await Future.delayed(const Duration(seconds: 1));

      if (mounted) Navigator.of(context).pop(); // volver al login
    } on TimeoutException {
      if (!mounted) return;
      _closeLoader();
      messenger.showSnackBar(
        const SnackBar(
            content: Text('Tiempo de espera agotado. Revisa tu conexión.')),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      _closeLoader();
      messenger.showSnackBar(
        SnackBar(content: Text(e.message ?? 'Error al enviar el correo')),
      );
    } catch (e) {
      if (!mounted) return;
      _closeLoader();
      messenger.showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ingresa tu correo electrónico y te enviaremos un link para restablecer tu contraseña.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Ingresa un correo'
                    : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.email_outlined),
                  label: const Text('Adicional en el examen'),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: !_busy
          ? FloatingActionButton.extended(
              onPressed: _sendResetEmail,
              icon: const Icon(Icons.send),
              label: const Text('Enviar'),
            )
          : null,
    );
  }
}
