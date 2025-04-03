import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../../models/transaction_model.dart';
import '../../../provider/transaction_provider.dart';
import 'package:quan_ly_tai_chinh/modules/dashboard/screens/accounts_tab.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: Text(
          "Reports",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple.shade700,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.deepPurple.shade50,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.deepPurple.shade700,
          unselectedLabelColor: Colors.deepPurple.shade200,
          indicatorColor: Colors.deepPurple.shade400,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "Analytics"),
            Tab(text: "Accounts"),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: _buildCircle(200, Colors.deepPurple.shade200.withOpacity(0.3)),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: _buildCircle(200, Colors.deepPurple.shade300.withOpacity(0.2)),
          ),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Consumer<TransactionProvider>(
              builder: (context, provider, _) {
                return TabBarView(
                  controller: _tabController,
                  children: [
                    AnalyticsTab(transactions: provider.transactions),
                    AccountScreen(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class AnalyticsTab extends StatelessWidget {
  final List<Transaction> transactions;
  const AnalyticsTab({super.key, required this.transactions});

  double get totalBudget => 5000000;

  double get totalExpenses => transactions
      .where((t) => t.type == "expense")
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalIncome => transactions
      .where((t) => t.type == "income")
      .fold(0.0, (sum, t) => sum + t.amount);

  double get remainingPercent =>
      totalBudget == 0 ? 0.0 : ((totalBudget - totalExpenses) / totalBudget).clamp(0.0, 1.0);

  String _formatCurrency(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
  }

  @override
  Widget build(BuildContext context) {
    final balance = totalIncome - totalExpenses;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCard(
            title: "Monthly Overview",
            child: Column(
              children: [
                _buildInfo("Total Income", totalIncome, Colors.green, Icons.arrow_upward),
                _buildInfo("Total Expenses", totalExpenses, Colors.red, Icons.arrow_downward),
                _buildInfo("Balance", balance, Colors.deepPurple, Icons.account_balance_wallet),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildCard(
            title: "Budget Analysis",
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CircularPercentIndicator(
                    radius: 60,
                    lineWidth: 12,
                    percent: remainingPercent,
                    animation: true,
                    animationDuration: 1500,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Used", style: TextStyle(fontSize: 12)),
                        Text(
                          "${((1 - remainingPercent) * 100).toStringAsFixed(1)}%",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    progressColor: Colors.deepPurple,
                    backgroundColor: Colors.deepPurple.shade100,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildBudget("Monthly Budget", totalBudget, Icons.account_balance),
                      const SizedBox(height: 12),
                      _buildBudget("Total Spent", totalExpenses, Icons.shopping_cart),
                      const SizedBox(height: 12),
                      _buildBudget("Remaining", totalBudget - totalExpenses, Icons.savings),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.shade100.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildInfo(String label, double value, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: TextStyle(color: color, fontSize: 14)),
          ),
          Text("${_formatCurrency(value)} đ",
              style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBudget(String label, double value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple.shade300, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            "$label: ${_formatCurrency(value)} đ",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
