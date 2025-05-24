import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 书架页面
class ShelfPage extends StatefulWidget {
  const ShelfPage({super.key});

  @override
  State<ShelfPage> createState() => _ShelfPageState();
}

class _ShelfPageState extends State<ShelfPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 头像按钮
                  IconButton(
                    onPressed: () {
                      // 打开个人信息抽屉
                      Scaffold.of(context).openEndDrawer();
                    },
                    icon: const Icon(Icons.account_circle),
                    iconSize: 30,
                  ),
                  // 更多按钮
                  PopupMenuButton<String>(
                    icon: Icon(Icons.add_circle_outline, size: 30),
                    color: Colors.white,
                    offset: Offset(-5, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    itemBuilder: (context) {
                      return <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'setting',
                          height: 30,
                          child: Text('设置'),
                        ),
                        PopupMenuDivider(height: 10),
                        PopupMenuItem<String>(
                          value: 'logout',
                          height: 30,
                          child: Text('退出登录'),
                          onTap: () {
                            // 退出登录
                            if (kDebugMode) {
                              print('退出登录');
                            }
                          },
                        ),
                      ];
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
