import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  static final AuthController instance = AuthController._internal();

  factory AuthController() => instance;

  AuthController._internal();

  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<void> setCurrentUser(User user) async {
    _currentUser = user;
  }

  void logout() {
    _currentUser = null;
  }

  void checkAuthStatus() {
    // Check if user is logged in from stored data
    // This will be implemented when we add persistence
    _currentUser = null; // Default to not logged in
  }
}
