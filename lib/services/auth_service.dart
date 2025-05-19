import 'package:reada/constants/api_prefix.dart';
import 'package:reada/utils/api_client.dart';

class AuthService {
  final ApiClient apiClient = ApiClient();

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
}
