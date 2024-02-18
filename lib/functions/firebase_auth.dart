import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utilities/static_data.dart';

class AuthFB {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setString("role", role.name);
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setString("role", role.name);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();

    SharedPreferences preference = await SharedPreferences.getInstance();
    preference.remove("role");
  }
}
