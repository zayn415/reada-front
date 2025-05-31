import 'package:hive_flutter/hive_flutter.dart';
import 'package:reada/constants/hive_box_pre.dart';
import 'package:reada/models/user_info.dart';

class UserStorage {
  // 保存最近登录用户ID
  Future<void> saveRecentUserId(int userId) async {
    final box = await Hive.openBox<int>(HiveBoxConstants.recentUser);
    await box.put(HiveBoxConstants.recentUser, userId);
  }

  // 获取最近登录用户ID
  Future<int?> getRecentUserId() async {
    final box = await Hive.openBox<int>(HiveBoxConstants.recentUser);
    return box.get(HiveBoxConstants.recentUser);
  }

  // 清除最近登录用户
  Future<void> clearRecentUser() async {
    final box = await Hive.openBox<int>(HiveBoxConstants.recentUser);
    await box.delete(HiveBoxConstants.recentUser);
  }

  // 获取用户信息的box名称
  String getBoxName(int userId) {
    return '${HiveBoxConstants.userBox}_$userId';
  }

  // 保存用户信息
  Future<void> saveUserInfo(UserInfo userInfo) async {
    final boxName = getBoxName(userInfo.userId);
    final box = await Hive.openBox<UserInfo>(boxName);
    await box.put('userInfo', userInfo);
  }

  // 获取用户信息
  Future<UserInfo?> getUserInfo(int userId) async {
    final boxName = getBoxName(userId);
    final box = await Hive.openBox<UserInfo>(boxName);
    return box.get('userInfo');
  }
}
