import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TransactionPieChart extends StatelessWidget {
  final List<double> monthlyData;
  final bool isYearly;

  const TransactionPieChart({
    super.key,
    required this.monthlyData,
    this.isYearly = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: PieChart(
        PieChartData(
          sections: List.generate(
            monthlyData.length,
                (index) => PieChartSectionData(
              value: monthlyData[index],
              title: isYearly ? 'T${index + 1}' : '${index + 1}',
              color: Colors.blue.withOpacity(0.5 + (index * 0.5 / monthlyData.length)),
              radius: 100,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          startDegreeOffset: 270,
        ),
      ),
    );
  }
}