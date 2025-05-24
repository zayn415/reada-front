import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _currentUserId = '';
  String _token = '';

  bool get isLoggedIn => _isLoggedIn;

  String get currentUserId => _currentUserId;

  String get token => _token;

  void login(String userId, String token) {
    _isLoggedIn = true;
    _currentUserId = userId;
    _token = token;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _currentUserId = '';
    notifyListeners();
  }
}
