import 'package:quan_ly_tai_chinh/models/transaction_model.dart';

import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '../../services/transaction_service.dart';

class AuthController {
  // Singleton pattern
  AuthController._privateConstructor();
  static final AuthController _instance = AuthController._privateConstructor();
  static AuthController get instance => _instance;

  // Current authenticated user
  User? currentUser;

  // Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  // Login with email and password
  Future<User> login(String email, String password) async {
    try {
      // Call the UserService to authenticate the user
      final user = await UserService.getUserByEmailAndPassword(email, password);

      // Store the user in memory
      currentUser = user;

      return user;
    } catch (e) {
      // Re-throw the exception to be handled by the UI
      throw e;
    }
  }

  // Logout the current user
  void logout() {
    currentUser = null;
  }

  // Get transactions for the current user
  Future<List<Transaction>> getCurrentUserTransactions() async {
    if (currentUser == null) {
      throw Exception('User not logged in');
    }

    return await TransactionService.getTransactionsByUserId(currentUser!.id!);
  }

  // Create a new transaction for the current user
  Future<Transaction> createTransaction({
    required String type,
    required double amount,
    required String category,
    required String paymentMethod,
    String status = 'Completed',
    required DateTime date,
    String? note,
  }) async {
    if (currentUser == null) {
      throw Exception('User not logged in');
    }

    // Create transaction object with current user ID
    final transaction = Transaction(
      userId: currentUser!.id,
      type: type,
      amount: amount,
      categoryName: category,
      paymentMethod: paymentMethod,
      status: status,
      date: date,
      note: note,
    );

    // Save transaction to the backend
    return await TransactionService.createTransaction(transaction);
  }

  // Check current user ID
  int? getCurrentUserId() {
    if (currentUser == null) {
      throw Exception('User not logged in');
    }
    return currentUser!.id;
  }

  // Check auth status
  void checkAuthStatus() {
    // This method can be used to check if the user is logged in
    // and update the currentUser variable accordingly.
    // For now, we will just set it to null.
    currentUser = null; // Default to not logged in
  }
}
