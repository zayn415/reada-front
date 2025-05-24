import 'package:hive_flutter/hive_flutter.dart';
import 'package:reada/constants/hive_box.dart';
import 'package:reada/models/user_info.dart';

class UserStorage {
  // 获取用户信息的box名称
  String getBoxName(String userId) {
    return '${HiveBoxConstants.userBox}_$userId';
  }

  // 保存用户信息
  Future<void> saveUserInfo(UserInfo userInfo) async {
    final boxName = getBoxName(userInfo.userId.toString());
    final box = await Hive.openBox<UserInfo>(boxName);
    await box.put('userInfo', userInfo);
  }

  // 获取用户信息
  Future<UserInfo?> getUserInfo(String userId) async {
    final boxName = getBoxName(userId);
    final box = await Hive.openBox<UserInfo>(boxName);
    return box.get('userInfo');
  }
}
