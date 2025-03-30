import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/transaction_provider.dart';
import '../../dashboard/charts/bar_chart.dart';
import '../../dashboard/charts/pie_chart.dart';
import '../../dashboard/charts/line_chart.dart';
import 'package:quan_ly_tai_chinh/modules/dashboard/charts/category_chart.dart';



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
                    BarChartWidget(transactions: transactions, type: "expense"),
                    PieChartWidget(transactions: transactions, type: "expense"),
                    LineChartWidget(transactions: transactions, type: "expense"),
                  ],
                ),
              ),
              // Income Tab
              SingleChildScrollView(
                child: Column(
                  children: [
                    BarChartWidget(transactions: transactions, type: "income"),
                    PieChartWidget(transactions: transactions, type: "income"),
                    LineChartWidget(transactions: transactions, type: "income"),
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
