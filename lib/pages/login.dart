import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reada/routes/routes.dart';
import 'package:reada/services/auth_service.dart';

// 登录页面
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late AuthService authService;
  Map<String, dynamic>? data;
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    authService = Provider.of<AuthService>(context, listen: false);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // 发送验证码
  Future<void> _handleSendCode() async {
    final email = _emailController.text;
    if (_emailController.text.isNotEmpty && EmailValidator.validate(email)) {
      try {
        // 发送验证码
        final result = await authService.sendVerificationCode(email);
        if (result['code'] != 200) {
          throw Exception('发送验证码失败：${result['message']}');
        }
        // 跳转到验证码页面
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamed(context, Routes.verification, arguments: email);
        });
      } catch (e) {
        throw Exception('发送验证码失败：$e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 返回按钮
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // 跳过登录，直接进入书架页面，清空路由栈
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.shelf,
                            (route) => false,
                          );
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  // 标题
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      '使用邮箱登录',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // 邮箱输入框
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: '邮箱',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 15,
                        ),
                        helperText: '',
                        helperStyle: TextStyle(fontSize: 11, height: 1.2),
                        errorStyle: TextStyle(fontSize: 11, height: 1.2),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red[700]!,
                            width: 1.1,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          // 聚焦错误状态边框
                          borderSide: BorderSide(
                            color: Colors.red[700]!,
                            width: 1.1,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        focusedBorder: OutlineInputBorder(
                          // 聚焦状态边框
                          borderSide: BorderSide(
                            color: Color(0xFF190019),
                            width: 1.1,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        suffixIcon: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _emailController,
                          builder: (context, value, child) {
                            return IconButton(
                              onPressed: () {
                                if (value.text.isNotEmpty) {
                                  _emailController.clear();
                                }
                              },
                              icon: Visibility(
                                visible: _emailController.text.isNotEmpty,
                                child: Icon(
                                  Icons.cancel,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入邮箱';
                        }
                        if (!EmailValidator.validate(value)) {
                          return '邮箱地址无效';
                        }
                        return null;
                      },
                    ),
                  ),
                  // 登录按钮
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      onPressed: _handleSendCode,
                      child: Text('发送验证码'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('密码登录'),
                      ),
                    ),
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
