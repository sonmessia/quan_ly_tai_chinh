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

class _ChartsScreenState extends State<ChartsScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        final transactions = transactionProvider.transactions;
        final expenses = transactions.where((t) => t.type.toLowerCase() == "expense").toList();
        final income = transactions.where((t) => t.type.toLowerCase() == "income").toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Financial Charts'),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Expenses'),
                Tab(text: 'Income'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              // Expenses Tab
              SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: BarChartWidget(transactions: expenses),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: PieChartWidget(transactions: expenses),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: LineChartWidget(transactions: expenses),
                      ),
                    ),
                  ],
                ),
              ),
              // Income Tab
              SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: BarChartWidget(transactions: income),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: PieChartWidget(transactions: income),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: LineChartWidget(transactions: income),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}