import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/transaction_provider.dart';
import '../../dashboard/charts/bar_chart.dart';
import '../../dashboard/charts/pie_chart.dart';
import '../../dashboard/charts/line_chart.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});

  @override
  _ChartsScreenState createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        final transactions = transactionProvider.transactions;

        return SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BarChartWidget(transactions: transactions),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PieChartWidget(transactions: transactions),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: LineChartWidget(transactions: transactions),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}