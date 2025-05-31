import 'package:flutter/cupertino.dart';
import 'package:reada/storage/user_storage.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  int _currentUserId = -1;
  String _token = '';

  bool get isLoggedIn => _isLoggedIn;

  int get currentUserId => _currentUserId;

  String get token => _token;

  Future<void> login(int userId, String token) async {
    _isLoggedIn = true;
    _currentUserId = userId;
    _token = token;
    await UserStorage().saveRecentUserId(userId);
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _currentUserId = -1;
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
