import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  int _currentUserId = -1;
  String _token = '';

  bool get isLoggedIn => _isLoggedIn;

  int get currentUserId => _currentUserId;

  String get token => _token;

  void login(int userId, String token) {
    _isLoggedIn = true;
    _currentUserId = userId;
    _token = token;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _currentUserId = -1;
    notifyListeners();
  }
}
