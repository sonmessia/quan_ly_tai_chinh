import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../models/transaction_model.dart';
class PieChartWidget extends StatelessWidget {
  final List<Transaction> transactions;

  const PieChartWidget({super.key, required this.transactions});

  Map<String, double> _getCategoryData() {
    final categoryTotals = <String, double>{};
    for (var transaction in transactions) {
      if (transaction.type.toLowerCase() == "expense") {
        categoryTotals.update(
          transaction.category,
              (value) => value + transaction.amount,
          ifAbsent: () => transaction.amount,
        );
      }
    }
    return categoryTotals;
  }

  @override
  Widget build(BuildContext context) {
    final categoryData = _getCategoryData();
    return Column(
      children: [
        const Text('Expenses by Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: categoryData.isEmpty
              ? const Center(child: Text('No expenses'))
              : PieChart(
            PieChartData(
              sections: categoryData.entries.map((e) {
                return PieChartSectionData(
                  value: e.value,
                  title: '${e.key}\n\$${e.value.toStringAsFixed(0)}',
                  color: Colors.blue.withOpacity(0.5 + (categoryData.keys.toList().indexOf(e.key) * 0.5 / categoryData.length)),
                  radius: 100,
                  titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}