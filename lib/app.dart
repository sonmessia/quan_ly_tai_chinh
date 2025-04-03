import 'package:flutter/material.dart';
import 'modules/auth/sign_in_screen.dart';
import 'modules/auth/sign_up_screen.dart';
import 'modules/dashboard/dashboard_screen.dart';
import 'modules/dashboard/screens/accounts_tab.dart';
import 'modules/splash/splash_screen.dart';
import 'modules/dashboard/screens/setting_screens.dart';

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
        '/signin': (context) => SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/account': (context) => AccountScreen(),
        '/settings': (context) => const SettingScreens(),
      },
    );
  }
}
