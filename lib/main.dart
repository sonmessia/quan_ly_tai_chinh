import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_chinh/modules/auth/sign_up_screen.dart';
import 'app.dart';
import 'provider/transaction_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize AuthController
  AuthController.instance.checkAuthStatus();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        // ...other providers...
      ],
      child: const MyApp(),
    ),
  );
}
