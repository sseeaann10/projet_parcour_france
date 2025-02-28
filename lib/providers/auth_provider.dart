import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  String? _currentUserId;
  String? _userName;

  bool get isLoggedIn => _currentUserId != null;
  String? get userId => _currentUserId;
  String? get userName => _userName;

  void login(String userId, String userName) {
    _currentUserId = userId;
    _userName = userName;
    notifyListeners();
  }

  void logout() {
    _currentUserId = null;
    _userName = null;
    notifyListeners();
  }
}
