import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:reada/routes/routes.dart';

// 登录页面
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final List<TextEditingController> _codeControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  bool _isObscure = true;
  bool _isSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    for (var c in _codeControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      // 这里添加实际的登录逻辑，例如调用 API
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('登录成功')));
      Navigator.pushReplacementNamed(context, Routes.home);
    }
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
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 返回按钮
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, Routes.home);
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ],
                  ),
                  // 标题
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      '使用邮箱登录',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 邮箱输入框
                  if (!_isSent)
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
                            borderRadius: BorderRadius.all(Radius.circular(16)),
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
                  if (_isSent)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          6,
                          (index) => SizedBox(
                            width: 40,
                            child: TextFormField(
                              controller: _codeControllers[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              decoration: const InputDecoration(
                                counterText: '',
                              ),
                              validator:
                                  (value) =>
                                      value?.isEmpty ?? true ? ' ' : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  // 登录按钮
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      // vertical: 16,
                    ),
                    child: ElevatedButton(
                      onPressed: _login,
                      child: Text(_isSent ? '登录' : '发送验证码'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
