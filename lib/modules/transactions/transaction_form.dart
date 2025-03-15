import 'package:flutter/material.dart';
import 'package:quan_ly_tai_chinh/core/config/constants.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_chinh/models/transaction_model.dart';
import 'package:quan_ly_tai_chinh/provider/transaction_provider.dart';

final TextEditingController amountController = TextEditingController();

class TransactionItem extends StatelessWidget {
  final String type; // 'expense' hoặc 'income'
  final String category;
  final String status;
  final String paymentMethod;

  const TransactionItem({
    Key? key,
    required this.type,
    required this.category,
    required this.status,
    required this.paymentMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            // Icon chính của giao dịch
            leading: Icon(
              type == 'expense'
                  ? TransactionIcons.expenseIcons[category]
                  : TransactionIcons.incomeIcons[category],
              color: type == 'expense' ? Colors.red : Colors.green,
              size: 32,
            ),
            title: Text(category),
            // Icon phương thức thanh toán
            subtitle: Row(
              children: [
                Icon(
                  TransactionIcons.paymentMethodIcons[paymentMethod],
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(paymentMethod),
              ],
            ),
            // Icon trạng thái
            trailing: Icon(
              TransactionIcons.statusIcons[status],
              color: _getStatusColor(status),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                if (amountController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter an amount')),
                  );
                  return;
                }
                final transaction = Transaction(
                  type: type,
                  category: category,
                  amount: double.parse(amountController.text),
                  paymentMethod: paymentMethod,
                  status: status,
                  date: DateTime.now(),
                );
                Provider.of<TransactionProvider>(context, listen: false).addTransaction(transaction);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[700],
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Add Transaction',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      case 'recurring':
        return Colors.blue;
      case 'scheduled':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}