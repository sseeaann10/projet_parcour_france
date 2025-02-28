import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  String? _currentUserId;

  bool get isLoggedIn => _currentUserId != null;
  String? get currentUserId => _currentUserId;

  void login(String userId) {
    _currentUserId = userId;
    notifyListeners();
  }

  void logout() {
    _currentUserId = null;
    notifyListeners();
  }
}
