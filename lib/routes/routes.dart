import 'package:flutter/material.dart';

import '../pages/login.dart';
import '../pages/message.dart';
import '../pages/mine.dart';
import '../pages/shelf.dart';

/// 路由常量
class Routes {
  static const String home = '/';
  static const String login = '/login';
  static const String mine = '/mine';
  static const String message = '/message';
}

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const ShelfPage());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case Routes.mine:
        return MaterialPageRoute(builder: (_) => const MinePage());
      case Routes.message:
        return MaterialPageRoute(builder: (_) => const MessagePage());
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(child: Text('未找到路由: ${settings.name}')),
              ),
        );
    }
  }
}
