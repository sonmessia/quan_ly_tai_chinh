import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';

class AuthService {
  static User? currentUser;
  static const String baseUrl = 'http://192.168.1.118:5000/api';
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Set current user on successful login
  static void setCurrentUser(User user) {
    currentUser = user;
  }

  // Get current user
  static User? getCurrentUser() {
    return currentUser;
  }

  // Check if user is logged in
  static bool isLoggedIn() {
    return currentUser != null;
  }

  // Log out (clear current user)
  static void logout() {
    currentUser = null;
  }

  static Future<User> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/signup'),
        headers: headers,
        body: json.encode({
          'email': email,
          'password': password,
          'username': username,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        return User.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to sign up: ${response.statusCode}');
      }
    } catch (e) {
      print('Sign up error: $e');
      throw Exception('Network error: $e');
    }
  }
}
