import 'package:reada/utils/api_client.dart';

import '../constants/api_prefix.dart';

class UserService {
  final ApiClient apiClient;

  UserService(this.apiClient);

  // 发送验证码
  Future<Map<String, dynamic>> sendVerificationCode(String email) async {
    return apiClient.postRequest(ApiPrefix.code, {
      'loginType': 'email',
      'account': email,
    });
  }

  // 登录
  Future<Map<String, dynamic>> login(String email, String code) async {
    return apiClient.postRequest(ApiPrefix.login, {
      'loginType': 'email',
      'account': email,
      'code': code,
    });
  }

  // 登出
  Future<Map<String, dynamic>> logout() async {
    return apiClient.postRequest(ApiPrefix.logout, {'userId': '123'});
  }
}
