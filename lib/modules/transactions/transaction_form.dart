import 'package:flutter/material.dart';
import 'package:quan_ly_tai_chinh/core/config/constants.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_chinh/models/transaction_model.dart';
import 'package:quan_ly_tai_chinh/provider/transaction_provider.dart';

class TransactionItem extends StatefulWidget {
  final String type;
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
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  final TextEditingController amountController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void _resetForm() {
    amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              widget.type == 'expense'
                  ? TransactionIcons.expenseIcons[widget.category]
                  : TransactionIcons.incomeIcons[widget.category],
              color: widget.type == 'expense' ? Colors.red : Colors.green,
              size: 32,
            ),
            title: Text(widget.category),
            subtitle: Row(
              children: [
                Icon(
                  TransactionIcons.paymentMethodIcons[widget.paymentMethod],
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(widget.paymentMethod),
              ],
            ),
            trailing: Icon(
              TransactionIcons.statusIcons[widget.status],
              color: _getStatusColor(widget.status),
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
                  type: widget.type,
                  category: widget.category,
                  amount: double.parse(amountController.text),
                  paymentMethod: widget.paymentMethod,
                  status: widget.status,
                  date: DateTime.now(),
                );
                Provider.of<TransactionProvider>(context, listen: false)
                    .addTransaction(transaction);
                _resetForm();
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