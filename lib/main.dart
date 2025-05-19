import 'package:flutter/material.dart';
import 'package:reada/routes/routes.dart';

import 'module/MainNavigator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'reada',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: Routes.shelf,
      onGenerateRoute: (settings) {
        if (settings.name == Routes.shelf) {
          return MaterialPageRoute(builder: (_) => const MainNavigator());
        }
        return AppRoutes.generateRoute(settings);
      },
    );
  }
}
