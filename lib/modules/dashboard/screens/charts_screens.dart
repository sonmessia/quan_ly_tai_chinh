import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/transaction_provider.dart';
import '../../dashboard/charts/bar_chart.dart';
import '../../dashboard/charts/pie_chart.dart';
import '../../dashboard/charts/line_chart.dart';
import 'package:quan_ly_tai_chinh/modules/dashboard/charts/category_chart.dart';
import '../../../models/transaction_model.dart';
import 'dart:ui';

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
    final theme = Theme.of(context);

    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        final List<Transaction> transactions = transactionProvider.transactions.cast<Transaction>();

        return Scaffold(
          backgroundColor: Colors.deepPurple.shade50,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.deepPurple.shade50,
            title: Text(
              'Financial Charts',
              style: TextStyle(
                color: Colors.deepPurple.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            centerTitle: true,
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.deepPurple.shade700,
              labelColor: Colors.deepPurple.shade700,
              unselectedLabelColor: Colors.deepPurple.shade300,
              tabs: const [
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_upward_rounded, size: 20),
                      SizedBox(width: 8),
                      Text('Expenses'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_downward_rounded, size: 20),
                      SizedBox(width: 8),
                      Text('Income'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildTabContent(
                transactions: transactions,
                type: "expense",
              ),
              _buildTabContent(
                transactions: transactions,
                type: "income",
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabContent({
    required List<Transaction> transactions,
    required String type,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
      ),
      child: SafeArea(
        bottom: true,
        child: Stack(
          children: [
            // Decorative background elements
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepPurple.shade200.withOpacity(0.3),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -80,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepPurple.shade300.withOpacity(0.2),
                ),
              ),
            ),

            // Main content
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildChartContainer(
                      child: BarChartWidget(transactions: transactions, type: type),
                    ),
                    _buildChartContainer(
                      child: PieChartWidget(transactions: transactions, type: type),
                    ),
                    _buildChartContainer(
                      child: LineChartWidget(transactions: transactions, type: type),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartContainer({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.shade100.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}