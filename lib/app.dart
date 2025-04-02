import 'package:flutter/material.dart';
import 'modules/auth/login_screen.dart';
import 'modules/dashboard/dashboard_screen.dart';
import 'modules/dashboard/screens/accounts_tab.dart';
import 'modules/splash/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Manager',
      theme: ThemeData.light(),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => SignInScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/account': (context) => AccountScreen(), // thêm route mới này
      },
    );
  }
}
