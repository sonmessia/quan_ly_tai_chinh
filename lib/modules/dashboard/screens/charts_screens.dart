import 'package:flutter/material.dart';
import '../../dashboard/charts/bar_chart.dart';
import '../../dashboard/charts/pie_chart.dart';
import '../../dashboard/charts/line_chart.dart';

class ChartsScreen extends StatefulWidget {
  @override
  _ChartsScreenState createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  final List<double> monthlyData = [
    1000,
    2000,
    1500,
    3000,
    2500,
    4000,
    3500,
    5000,
    4500,
    6000,
    5500,
    7000,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Charts",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text("Bar Chart",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                TransactionBarChart(monthlyData: monthlyData),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text("Pie Chart",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                TransactionPieChart(monthlyData: monthlyData),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text("Line Chart",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                TransactionLineChart(monthlyData: monthlyData),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
