import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:reada/models/user_info.dart';
import 'package:reada/providers/user_provider.dart';
import 'package:reada/routes/routes.dart';
import 'package:reada/services/user_service.dart';
import 'package:reada/storage/user_storage.dart';

import '../constants/colors.dart';

// 验证码页面
class VerificationPage extends StatefulWidget {
  final String email;

  const VerificationPage({super.key, required this.email});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _formKey = GlobalKey<FormState>();
  late UserService userService;
  late UserStorage userStorage;
  late String email;
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userService = Provider.of<UserService>(context, listen: false);
    userStorage = UserStorage();
    email = widget.email;
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  // 重发验证码
  Future<void> _handleResendCode() async {
    try {
      final result = await userService.sendVerificationCode(email);
      if (result['code'] != 200) {
        throw Exception('发送验证码失败：${result['message']}');
      }
    } catch (e) {
      throw Exception('发送验证码失败：$e');
    }
  }

  // 登录
  Future<void> _handleLogin(String code) async {
    try {
      final result = await userService.login(email, code);
      _handleLoginResult(result);
    } catch (e) {
      throw Exception('登录失败：$e');
    }
  }

  void _handleLoginResult(Map<String, dynamic> result) {
    if (!mounted) return;
    final statusCode = result['code'] as int? ?? -1;
    final message = result['message'] as String? ?? '未知错误';

    if (statusCode != 200) {
      if (message == '验证码错误') {
        showDialog(
          context: context,
          builder:
              (ctx) => AlertDialog(
                title: const Text('验证码错误'),
                content: const Text('请出入正确的验证码'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      _codeController.clear();
                    },
                    child: const Text('确定'),
                  ),
                ],
              ),
        );
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('登录失败：$message')));
      return;
    }
    final data = result['data'] as Map<String, dynamic>?;
    if (data == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('登录失败：$message')));
      return;
    }
    final token = data['token'] as String;
    final userId = data['userId'] as int;
    final UserInfo userInfo = UserInfo(userId: userId, token: token);
    userStorage.saveUserInfo(userInfo).then((_) {
      if (!mounted) return;
      Provider.of<UserProvider>(context, listen: false).login(userId, token);
      Navigator.pushReplacementNamed(context, Routes.shelf);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 返回按钮
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ],
                  ),
                  // 标题
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16,
                    ),
                    child: Text(
                      '输入验证码',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 16),
                    child: Text(email, style: TextStyle(color: Colors.grey)),
                  ),
                  // 验证码输入框
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Pinput(
                          length: 6,
                          controller: _codeController,
                          showCursor: false,
                          defaultPinTheme: PinTheme(
                            width: 50,
                            height: 50,
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          focusedPinTheme: PinTheme(
                            width: 50,
                            height: 50,
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: ColorConstants.borderColorLightPurple,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onCompleted: (value) {
                            if (_formKey.currentState!.validate()) {
                              _handleLogin(value);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  // 重发
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('没收到验证码？'),
                      TextButton(
                        onPressed: _handleResendCode,
                        child: const Text(
                          '重发',
                          style: TextStyle(
                            color: ColorConstants.textColorDarkPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
