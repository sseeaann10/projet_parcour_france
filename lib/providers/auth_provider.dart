import 'package:flutter/foundation.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool get isLoggedIn => _currentUser != null;
  User? get currentUser => _currentUser;

  void login(String email, String password) {
    final user = staticUsers.firstWhere(
      (user) => user.email == email,
      orElse: () => throw Exception('Utilisateur non trouvé'),
    );

    if (!user.checkPassword(password)) {
      throw Exception('Mot de passe incorrect');
    }

    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void register(String name, String email, String password) {
    if (staticUsers.any((user) => user.email == email)) {
      throw Exception('Cet email est déjà utilisé');
    }

    final newUser = User.create(
      id: 'user${staticUsers.length + 1}',
      name: name,
      email: email,
      password: password,
    );

    staticUsers.add(newUser);
    _currentUser = newUser;
    notifyListeners();
  }
}
