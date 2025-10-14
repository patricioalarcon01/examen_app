import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();
  static final AuthService I = AuthService._();

  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();
  User? get currentUser => FirebaseAuth.instance.currentUser;

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
