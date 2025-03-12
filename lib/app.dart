import 'package:flutter/material.dart';
import 'modules/auth/login_screen.dart';
import 'modules/dashboard/dashboard_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Manager',
      theme: ThemeData.light(),
      initialRoute: '/dashboard',
      routes: {
        '/login': (context) => SignInScreen(),
        '/dashboard': (context) => DashboardScreen(),
      },
    );
  }
}
