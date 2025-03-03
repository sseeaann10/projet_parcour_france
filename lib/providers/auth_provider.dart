import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _currentUser;

  bool get isLoggedIn => _currentUser != null;
  String? get userId => _currentUser?.id;
  String? get userName => _currentUser?.name;
  User? get currentUser => _currentUser;

  // Inscription
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

  // Connexion
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

  // Déconnexion
  Future<void> logout() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // Vérifier l'état de connexion au démarrage
  Future<void> checkAuthState() async {
    final currentUser = _authService.currentUser;
    if (currentUser != null) {
      // Récupérer les données utilisateur depuis Firestore
      try {
        _currentUser = await _authService.signIn(
          email: currentUser.email!,
          password:
              '', // Le mot de passe n'est pas nécessaire car l'utilisateur est déjà connecté
        );
        notifyListeners();
      } catch (e) {
        // En cas d'erreur, déconnecter l'utilisateur
        await logout();
      }
    }
  }
}
