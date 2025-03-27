import 'package:flutter/material.dart';
import '../../../widgets/transaction_bar_chart.dart';
import '../../../models/transaction_model.dart';
class BarChartWidget extends StatelessWidget {
  final List<Transaction> transactions;

  const BarChartWidget({super.key, required this.transactions});

  List<double> _getMonthlyData() {
    final monthlyData = List<double>.filled(12, 0);
    for (var transaction in transactions) {
      final month = transaction.date.month - 1;
      if (transaction.type.toLowerCase() == "income") {
        monthlyData[month] += transaction.amount;
      } else {
        monthlyData[month] -= transaction.amount;
      }
    }
    return monthlyData;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Monthly Balance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        TransactionBarChart(monthlyData: _getMonthlyData()),
      ],
    );
  }
}