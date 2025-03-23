import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TransactionPieChart extends StatelessWidget {
  final List<PieData> data;

  const TransactionPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          sectionsSpace: 0,
          centerSpaceRadius: 40,
          sections: data.map((item) {
            return PieChartSectionData(
              color: item.color,
              value: item.value,
              title: '${item.title}\n${item.value.toStringAsFixed(1)}%',
              radius: 50,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }).toList(),
          borderData: FlBorderData(show: false)
        ),
      ),
    );
  }
}

class PieData {
  final String title;
  final double value;
  final Color color;

  PieData({
    required this.title,
    required this.value,
    required this.color,
  });
}