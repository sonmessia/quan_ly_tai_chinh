import '../models/user_model.dart';
import 'api_service.dart';

class UserService {
  static const String endpoint = '/users';

  // Get all users
  static Future<List<User>> getUsers() async {
    final response = await ApiService.get(endpoint);
    return (response as List).map((json) => User.fromJson(json)).toList();
  }

  // Get user by ID
  static Future<User> getUserById(String id) async {
    final response = await ApiService.get('$endpoint/$id');
    return User.fromJson(response);
  }

  // Get user by email and password
  static Future<User> getUserByEmailAndPassword(
      String email, String password) async {
    final response = await ApiService.post(
        '$endpoint/login', {'email': email, 'password': password});
    return User.fromJson(response);
  }

  // Create new user
  static Future<User> createUser(User user) async {
    final response = await ApiService.post(endpoint, user.toJson());
    return User.fromJson(response);
  }

  // Update user
  static Future<User> updateUser(String id, User user) async {
    final response = await ApiService.put('$endpoint/$id', user.toJson());
    return User.fromJson(response);
  }

  // Delete user
  static Future<void> deleteUser(int id) async {
    await ApiService.delete('$endpoint/$id');
  }
}
