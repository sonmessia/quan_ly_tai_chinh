import 'package:flutter/material.dart';
import 'package:quan_ly_tai_chinh/models/transaction_model.dart';
import 'package:quan_ly_tai_chinh/modules/transactions/transactionDetailScreen.dart';
import 'package:quan_ly_tai_chinh/widgets/transaction_card.dart'; // nếu có

class TransactionsListScreen extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionsListScreen({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TransactionDetailScreen(transaction: transaction),
              ),
            );
          },
          child: TransactionCard(transaction: transaction),
        );
      },
    );
  }
}
