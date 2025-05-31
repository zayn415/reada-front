import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:reada/models/user_info.dart';
import 'package:reada/providers/user_provider.dart';
import 'package:reada/routes/routes.dart';
import 'package:reada/services/user_service.dart';
import 'package:reada/utils/api_client.dart';

import 'module/MainNavigator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserInfoAdapter());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ProxyProvider<UserProvider, ApiClient>(
          update:
              (_, userProvider, _) =>
                  ApiClient(Dio(), () => userProvider.token),
        ),

        ProxyProvider<ApiClient, UserService>(
          update: (_, apiClient, _) => UserService(apiClient),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
