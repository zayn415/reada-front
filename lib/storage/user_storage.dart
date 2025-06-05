import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reada/constants/hive_box_pre.dart';
import 'package:reada/models/user_info.dart';

class UserStorage {
  UserStorage._internal();

  static final UserStorage _instance = UserStorage._internal();

  factory UserStorage() => _instance;

  final Map<String, Box> _boxCache = {};

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserInfoAdapter());
  }

  // 清除 box 缓存
  Future<void> clearBoxCache() async {
    for (final box in _boxCache.values) {
      await box.clear();
    }
    _boxCache.clear();
  }

  // 获取box
  Future<Box<T>> _getBox<T>(String boxName) async {
    if (_boxCache.containsKey(boxName)) {
      return _boxCache[boxName] as Box<T>;
    }
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box<T>(boxName);
      _boxCache[boxName] = box;
      return box;
    }
    final box = await Hive.openBox<T>(boxName);
    _boxCache[boxName] = box;
    return box;
  }

  // 保存最近登录用户ID
  Future<void> saveRecentUserId(String userId) async {
    if (kDebugMode) {
      print('保存最近登录用户ID：$userId');
    }
    final box = await _getBox<String>(HiveBoxConstants.recentUser);
    box.put(HiveBoxConstants.recentUser, userId);
  }

  // 获取最近登录用户ID
  Future<String?> getRecentUserId() async {
    final box = await _getBox<String>(HiveBoxConstants.recentUser);
    return box.get(HiveBoxConstants.recentUser);
  }

  // 清除最近登录用户
  Future<void> clearRecentUser() async {
    final box = await _getBox<int>(HiveBoxConstants.recentUser);
    await box.delete(HiveBoxConstants.recentUser);
  }

  // 获取用户信息的box名称
  String getBoxName(String userId) {
    return '${HiveBoxConstants.userBox}_$userId';
  }

  // 保存用户信息
  Future<void> saveUserInfo(UserInfo userInfo) async {
    final box = await _getBox<UserInfo>(getBoxName(userInfo.userId));
    await box.put('userInfo', userInfo);
    await saveRecentUserId(userInfo.userId);
  }

  // 获取用户信息
  Future<UserInfo?> getUserInfo(String userId) async {
    final box = await _getBox<UserInfo>(getBoxName(userId));
    return box.get('userInfo');
  }
}
