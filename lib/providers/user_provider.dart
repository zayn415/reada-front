import 'package:flutter/cupertino.dart';
import 'package:reada/storage/user_storage.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _currentUserId = '';
  String _token = '';

  bool get isLoggedIn => _isLoggedIn;

  String get currentUserId => _currentUserId;

  String get token => _token;

  Future<void> login(String userId, String token) async {
    _isLoggedIn = true;
    _currentUserId = userId;
    _token = token;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _currentUserId = '';
    _token = '';
    await UserStorage().clearRecentUser();
    notifyListeners();
  }

  Future<void> loadUserInfo() async {
    // 从本地存储中加载用户信息
    final storage = UserStorage();
    final userId = await storage.getRecentUserId();
    if (userId != null) {
      final userInfo = await storage.getUserInfo(userId);
      if (userInfo != null) {
        _isLoggedIn = true;
        _currentUserId = userId;
        _token = userInfo.token;
        notifyListeners();
      }
    }
  }
}
