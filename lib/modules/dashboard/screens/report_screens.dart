import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../../models/transaction_model.dart';
import '../../../provider/transaction_provider.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

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
    final transactions = Provider.of<TransactionProvider>(context).transactions;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Reports",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.deepPurple,
          unselectedLabelColor: Colors.black54,
          indicatorColor: Colors.deepPurple,
          indicatorWeight: 2,
          tabs: const [
            Tab(text: "Analytics"),
            Tab(text: "Accounts"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AnalyticsTab(transactions: transactions),
          const Center(child: Text("Accounts View", style: TextStyle(color: Colors.black87, fontSize: 16))),
        ],
      ),
    );
  }
}

class AnalyticsTab extends StatelessWidget {
  final List<Transaction> transactions;

  const AnalyticsTab({super.key, required this.transactions});

  double get totalBudget => 5000000;

  double get totalExpenses => transactions
      .where((t) => t.type.toLowerCase() == "expense")
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalIncome => transactions
      .where((t) => t.type.toLowerCase() == "income")
      .fold(0.0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpenses;
  double get remainingPercent => ((totalBudget - totalExpenses) / totalBudget).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCard(
            title: "Monthly Overview",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow("Total Income", totalIncome, Colors.green),
                const SizedBox(height: 8),
                _infoRow("Total Expenses", totalExpenses, Colors.red),
                const SizedBox(height: 8),
                _infoRow("Balance", balance, Colors.blue),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: "Monthly Budget",
            child: Row(
              children: [
                CircularPercentIndicator(
                  radius: 45,
                  lineWidth: 8,
                  percent: remainingPercent,
                  animation: true,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Used", style: TextStyle(fontSize: 10, color: Colors.black54)),
                      Text("${((1 - remainingPercent) * 100).toStringAsFixed(1)}%",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  progressColor: Colors.deepPurple,
                  backgroundColor: Colors.grey.shade300,
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _budgetRow("Budget:", totalBudget),
                    _budgetRow("Expenses:", totalExpenses),
                    _budgetRow("Remaining:", totalBudget - totalExpenses),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, double value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w600)),
        Text(value.toStringAsFixed(0), style: const TextStyle(fontSize: 14, color: Colors.black87)),
      ],
    );
  }

  Widget _budgetRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 13)),
          const SizedBox(width: 5),
          Text(value.toStringAsFixed(0),
              style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
