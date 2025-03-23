import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_chinh/provider/transaction_provider.dart';
import 'package:intl/intl.dart';

class RecordsScreen extends StatelessWidget {
  final DateFormat dateFormat = DateFormat('MMM dd, yyyy');

  RecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
          if (transactionProvider.transactions.isEmpty) {
            return Center(
              child: Text('No transactions yet'),
            );
          }
          return ListView.builder(
            itemCount: transactionProvider.transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactionProvider.transactions[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: Icon(
                    transaction.type.toLowerCase() == "income"
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    color: transaction.type.toLowerCase() == "income"
                        ? Colors.green
                        : Colors.red,
                  ),
                  title: Text(transaction.category),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${transaction.paymentMethod} • ${transaction.status}'),
                      Text(
                        dateFormat.format(transaction.date),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  trailing: Text(
                    '\$${transaction.amount}',
                    style: TextStyle(
                      color: transaction.type.toLowerCase() == "income"
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}