import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reada/models/user_info.dart';
import 'package:reada/providers/user_provider.dart';
import 'package:reada/storage/user_storage.dart';

import '../routes/routes.dart';

// 我的页面
class MinePage extends StatelessWidget {
  const MinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final Future<UserInfo?> userInfo = UserStorage().getUserInfo(
      userProvider.currentUserId,
    );
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              if (!userProvider.isLoggedIn)
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.login);
                  },
                  child: Text('登录'),
                )
              else
                Column(
                  children: [
                    Text('用户Id： ${userProvider.currentUserId}'),
                    Text('token: ${userProvider.token}'),
                    FutureBuilder<UserInfo?>(
                      future: userInfo,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text('用户ID: ${snapshot.data?.userId}');
                        }
                        return Text('加载中...');
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        userProvider.logout();
                        _handleLogout();
                      },
                      child: Text('退出登录'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {}
}
