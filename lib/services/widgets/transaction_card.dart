import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_chinh/models/transaction_model.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          transaction.type.toLowerCase() == 'income' ? Icons.arrow_downward : Icons.arrow_upward,
          color: transaction.type.toLowerCase() == 'income' ? Colors.green : Colors.red,
          size: 28,
        ),
        title: Text(
          transaction.category,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: Text(
          '${transaction.type.toLowerCase() == 'income' ? '+' : '-'}${formatter.format(transaction.amount)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: transaction.type.toLowerCase() == 'income' ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}
