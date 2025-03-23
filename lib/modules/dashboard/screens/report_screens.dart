import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../models/transaction_model.dart';
import '../charts/line_chart.dart';

class ReportsScreen extends StatefulWidget {
  final List<Transaction> transactions;

  const ReportsScreen({super.key, required this.transactions});

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.white60,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          tabs: const [
            Tab(text: "Analytics"),
            Tab(text: "Accounts"),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AnalyticsTab(transactions: widget.transactions),
          const Center(child: Text("Accounts View",
              style: TextStyle(color: Colors.white, fontSize: 18)
          )),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}

class AnalyticsTab extends StatelessWidget {
  final List<Transaction> transactions;

  const AnalyticsTab({super.key, required this.transactions});

  double get totalBudget => 5510000;

  double get totalExpenses => transactions
      .where((t) => t.type.toLowerCase() == "expense")
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalIncome => transactions
      .where((t) => t.type.toLowerCase() == "income")
      .fold(0.0, (sum, t) => sum + t.amount);

  double get remaining => totalBudget - totalExpenses;
  double get remainingPercent => (remaining / totalBudget).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _buildCard(
              title: "Monthly Statistics",
              child: Column(
                children: [
                  _buildRow("Current", "Expenses", "Income"),
                  _buildRow("",
                      totalExpenses.toStringAsFixed(0),
                      totalIncome.toStringAsFixed(0)
                  ),
                  const SizedBox(height: 20),
                  LineChartWidget(transactions: transactions),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _buildCard(
              title: "Monthly Budget",
              child: Row(
                children: [
                  CircularPercentIndicator(
                    radius: 50,
                    lineWidth: 8,
                    percent: remainingPercent,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Remaining",
                            style: TextStyle(color: Colors.white70,
                                fontSize: 10)
                        ),
                        Text("${(remainingPercent * 100).toStringAsFixed(2)}%",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold
                            )
                        ),
                      ],
                    ),
                    progressColor: Colors.yellow,
                    backgroundColor: Colors.white24,
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBudgetRow("Remaining:", remaining),
                      _buildBudgetRow("Budget:", totalBudget),
                      _buildBudgetRow("Expenses:", totalExpenses),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String month, String expenseLabel, String incomeLabel) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(month, style: TextStyle(color: Colors.white70, fontSize: 16)),
          Text(expenseLabel, style: TextStyle(color: Colors.red, fontSize: 16)),
          Text(incomeLabel, style: TextStyle(color: Colors.green, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildBudgetRow(String label, double amount) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: Colors.white70, fontSize: 14)),
          SizedBox(width: 5),
          Text(amount.toStringAsFixed(0), style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
