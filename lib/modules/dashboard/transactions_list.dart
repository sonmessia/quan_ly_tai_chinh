import 'package:flutter/material.dart';
import 'package:quan_ly_tai_chinh/models/transaction_model.dart';
import 'package:quan_ly_tai_chinh/modules/transactions/transactionDetailScreen.dart';
import 'package:quan_ly_tai_chinh/services/widgets/transaction_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransactionsListScreen extends StatelessWidget {
  final String userId;

  const TransactionsListScreen({
    super.key,
    required this.userId,
  });
  static const String baseUrl = 'http://192.168.1.118:5000/api';
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  Future<List<Transaction>> fetchTransactions() async {
    final response = await http.get(
      Uri.parse('$baseUrl/transactions/user/$userId'),
      headers: {
        'Content-Type': 'application/json',
        // Add your authentication header here if needed
        // 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Transaction.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Transaction>>(
      future: fetchTransactions(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final transactions = snapshot.data ?? [];

        if (transactions.isEmpty) {
          return const Center(child: Text('No transactions found'));
        }

        return ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        TransactionDetailScreen(transaction: transaction),
                  ),
                );
              },
              child: TransactionCard(transaction: transaction),
            );
          },
        );
      },
    );
  }
}
