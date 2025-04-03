import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/transaction_model.dart';
import 'api_service.dart';

class TransactionService {
  static const String baseUrl = 'http://192.168.1.218:5000/api';
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  static const String endpoint = '/transactions';

  // Add static user ID field
  static int? _userId;

  // Method to set user ID after login
  static void setUserId(int userId) {
    _userId = userId;
  }

  // Get all transactions for a specific user
  static Future<List<Transaction>> getTransactionsByUserId(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint/user/$userId'),
        headers: headers,
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Transaction.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load transactions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching transactions: $e');
      return [];
    }
  }

  // Get transaction by ID
  static Future<Transaction> getTransactionById(int id) async {
    try {
      final response = await ApiService.get('$endpoint/$id');

      print('API Response: ${response.body}');
      print('Status Code: ${response.statusCode}');

      return Transaction.fromJson(response);
    } catch (e) {
      print('Error fetching transaction: $e');
      throw Exception('Failed to fetch transaction: $e');
    }
  }

  // Create new transaction
  static Future<Transaction> createTransaction(Transaction transaction) async {
    try {
      final response = await ApiService.post(endpoint, transaction.toJson());

      print('API Response: ${response.body}');
      print('Status Code: ${response.statusCode}');

      return Transaction.fromJson(response);
    } catch (e) {
      print('Error creating transaction: $e');
      throw Exception('Failed to create transaction: $e');
    }
  }

  // Update transaction
  static Future<Transaction> updateTransaction(
      String id, Transaction transaction) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint/$id'),
        headers: headers,
        body: json.encode({
          'type': transaction.type,
          'user_id': transaction.userId,
          'category_name': transaction.categoryName,
          'amount': transaction.amount,
          'payment_method': transaction.paymentMethod,
          'status': transaction.status,
          'note': transaction.note,
        }),
      );

      print('Update Response: ${response.body}');

      if (response.statusCode == 200) {
        return Transaction.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update transaction: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating transaction: $e');
      throw Exception('Network error: $e');
    }
  }

  // Delete transaction
  static Future<void> deleteTransaction(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint/$id'),
        headers: headers,
      );

      print('Delete Response: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete transaction');
      }
    } catch (e) {
      print('Error deleting transaction: $e');
      throw Exception('Network error: $e');
    }
  }

  static Future<Transaction> addTransaction(Transaction transaction) async {
    try {
      final body = transaction.toJson();
      print('Sending transaction data: ${json.encode(body)}'); // Debug print

      final response = await http.post(
        Uri.parse('$baseUrl/transactions'),
        headers: headers,
        body: json.encode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return Transaction.fromJson(responseData);
      } else {
        throw Exception(
            'Failed to add transaction: ${response.statusCode}\nResponse: ${response.body}');
      }
    } catch (e) {
      print('Error adding transaction: $e');
      throw Exception('Network error: $e');
    }
  }
}
