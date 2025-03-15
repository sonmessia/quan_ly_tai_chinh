import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ReportsScreen extends StatefulWidget {
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
        title: Text("Reports", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.white60,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          tabs: [
            Tab(text: "Analytics"),
            Tab(text: "Accounts"),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AnalyticsTab(),
          Center(child: Text("Accounts View", style: TextStyle(color: Colors.white, fontSize: 18))),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}

class AnalyticsTab extends StatelessWidget {
  final double budget = 5510000;
  final double expenses = 26905;
  final double remaining = 5483095;
  final double remainingPercent = 99.51 / 100;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          _buildCard(
            title: "Monthly Statistics",
            child: Column(
              children: [
                _buildRow("Mar", "Expenses", "Income"),
                _buildRow("", "26,905", "7,000,000"),
              ],
            ),
          ),
          SizedBox(height: 10),
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
                      Text("Remaining", style: TextStyle(color: Colors.white70, fontSize: 10)),
                      Text("${(remainingPercent * 100).toStringAsFixed(2)}%", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  progressColor: Colors.yellow,
                  backgroundColor: Colors.white24,
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBudgetRow("Remaining:", remaining),
                    _buildBudgetRow("Budget:", budget),
                    _buildBudgetRow("Expenses:", expenses),
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
