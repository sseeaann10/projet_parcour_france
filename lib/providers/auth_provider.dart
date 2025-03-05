import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _currentUser;

  bool get isLoggedIn => _currentUser != null;
  String? get userId => _currentUser?.id;
  String? get userName => _currentUser?.name;
  String? get userEmail => _currentUser?.email;  // Getter for email
  User? get currentUser => _currentUser;

  // Inscription (sign-up)
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    _currentUser = await _authService.signUp(
      email: email,
      password: password,
      name: name,
    );
    notifyListeners();
  }

  // Connexion (sign-in)
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _currentUser = await _authService.signIn(
      email: email,
      password: password,
    );
    notifyListeners();
  }

  // Déconnexion (log-out)
  Future<void> logout() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // Vérifier l'état de connexion au démarrage (Check auth state at startup)
  Future<void> checkAuthState() async {
    final currentFirebaseUser = _authService.getCurrentUser();
    if (currentFirebaseUser != null) {
      try {
        // Retrieve the user profile from Firestore
        final user = await _authService.signIn(
          email: currentFirebaseUser.email!,
          password: '',  // No password needed for already authenticated users
        );
        _currentUser = user;  // Store the current user
      } catch (e) {
        // In case of an error, log the user out
        await logout();
      }
    } else {
      _currentUser = null; // No user signed in
    }
    notifyListeners();  // Notify listeners about the state change
  }
}
