import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../screens/home_screen.dart';
import '../screens/password_reset_screen.dart';
import '../screens/register_screen.dart';

class _OverlayLoader {
  static OverlayEntry? _entry;

  static void show(BuildContext context, String message) {
    if (_entry != null) return;
    _entry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          ModalBarrier(
            dismissible: false,
            color: Colors.black.withValues(alpha: 0.35),
          ),
          Center(
            child: Material(
              color: Colors.white,
              elevation: 12,
              borderRadius: BorderRadius.circular(16),
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
                    Text('Ingresando...'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _obscure = true;
  bool _busy = false;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _showLoader() => _OverlayLoader.show(context, 'Ingresando...');
  void _closeLoader() => _OverlayLoader.hide();

  Future<void> _signIn() async {
    if (_busy) return;
    if (!_form.currentState!.validate()) return;

    setState(() => _busy = true);
    _showLoader();

    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);

    try {
      final cred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _email.text.trim(),
            password: _pass.text,
          )
          .timeout(const Duration(seconds: 12));

      _closeLoader();
      await Future.delayed(const Duration(milliseconds: 200));

      if (!mounted) return;

      if (cred.user != null) {
        nav.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (_) => false,
        );
      } else {
        messenger.showSnackBar(
          const SnackBar(content: Text('No se pudo iniciar sesión.')),
        );
      }
    } on TimeoutException {
      _closeLoader();
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Tiempo de espera agotado. Verifica tu conexión.'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      _closeLoader();
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(_friendlyError(e))),
      );
    } catch (e) {
      _closeLoader();
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Error inesperado: $e')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _friendlyError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Correo inválido.';
      case 'user-disabled':
        return 'Usuario deshabilitado.';
      case 'user-not-found':
        return 'Usuario no encontrado.';
      case 'wrong-password':
        return 'Contraseña incorrecta.';
      case 'too-many-requests':
        return 'Demasiados intentos, intenta más tarde.';
      default:
        return e.message ?? 'Error de autenticación.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.sports_soccer,
                    size: 70,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Iniciar sesión',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Campo correo
                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(
                      labelText: 'Correo',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Ingrese su correo'
                        : null,
                  ),
                  const SizedBox(height: 12),

                  // Campo contraseña
                  TextFormField(
                    controller: _pass,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    obscureText: _obscure,
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Ingrese su contraseña'
                        : null,
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _busy ? null : _signIn,
                      icon: const Icon(Icons.login),
                      label: const Text('Ingresar'),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Recuperar contraseña
                  TextButton(
                    onPressed: _busy
                        ? null
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const PasswordResetScreen(),
                              ),
                            );
                          },
                    child: const Text('¿Olvidaste tu contraseña?'),
                  ),

                  // Crear cuenta
                  TextButton(
                    onPressed: _busy
                        ? null
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            );
                          },
                    child: const Text('Crear una cuenta nueva'),
                  ),

                  const SizedBox(height: 6),
                  if (AuthService.I.currentUser != null)
                    Text(
                      'Sesión activa: ${AuthService.I.currentUser!.email}',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
