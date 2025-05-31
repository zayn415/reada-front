import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reada/providers/user_provider.dart';
import 'package:reada/storage/user_storage.dart';

import '../routes/routes.dart';

// 我的页面
class MinePage extends StatelessWidget {
  const MinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final Future<int?> userId = UserStorage().getRecentUserId();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              FutureBuilder<int?>(
                future: userId,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text('最近登录用户Id： ${snapshot.data}');
                  }
                  return Text('加载中...');
                },
              ),
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
                    FutureBuilder<int?>(
                      future: userId,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text('最近登录用户Id： ${snapshot.data}');
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
