import 'package:hive/hive.dart';

part 'user_info.g.dart';

@HiveType(typeId: 0)
class UserInfo extends HiveObject {
  @HiveField(0)
  final String token;

  @HiveField(1)
  final String userId;

  UserInfo({required this.token, required this.userId});
}
