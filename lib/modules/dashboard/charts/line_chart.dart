import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../widgets/transaction_line_chart.dart';
import '../../../models/transaction_model.dart';
import 'package:collection/collection.dart';

class LineChartWidget extends StatelessWidget {
  final List<Transaction> transactions;

  const LineChartWidget({super.key, required this.transactions});

  List<FlSpot> _getDailyData() {
    final sortedTransactions = [...transactions]..sort((a, b) => a.date.compareTo(b.date));
    final dailyTotals = <DateTime, double>{};

    for (var transaction in sortedTransactions) {
      final date = DateTime(transaction.date.year, transaction.date.month, transaction.date.day);
      dailyTotals.update(
        date,
            (value) => value + (transaction.type.toLowerCase() == "income" ? transaction.amount : -transaction.amount),
        ifAbsent: () => transaction.type.toLowerCase() == "income" ? transaction.amount : -transaction.amount,
      );
    }

    return dailyTotals.entries.mapIndexed((index, e) => FlSpot(index.toDouble(), e.value)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Balance Trend', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        TransactionLineChart(monthlyData: _getDailyData().map((spot) => spot.y).toList()),
      ],
    );
  }
}