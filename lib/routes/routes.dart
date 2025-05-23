import 'package:flutter/material.dart';
import 'package:reada/pages/verification_page.dart';

import '../pages/login.dart';
import '../pages/message.dart';
import '../pages/mine.dart';
import '../pages/shelf.dart';

// 路由常量
class Routes {
  static const String shelf = '/';
  static const String login = '/login';
  static const String mine = '/mine';
  static const String message = '/message';
  static const String verification = '/verification';
}

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.shelf:
        return MaterialPageRoute(builder: (_) => const ShelfPage());
      case Routes.login:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;
            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case Routes.mine:
        return MaterialPageRoute(builder: (_) => const MinePage());
      case Routes.message:
        return MaterialPageRoute(builder: (_) => const MessagePage());
      case Routes.verification:
        return PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) =>
                  VerificationPage(email: settings.arguments as String),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;
            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
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
