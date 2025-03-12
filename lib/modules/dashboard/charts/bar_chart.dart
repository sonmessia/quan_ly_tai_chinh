import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TransactionBarChart extends StatelessWidget {
  final List<double> monthlyData;
  final bool isYearly;

  const TransactionBarChart({
    super.key,
    required this.monthlyData,
    this.isYearly = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: monthlyData.reduce((a, b) => a > b ? a : b) * 1.2,
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 60),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value < 0 || value >= monthlyData.length) return const Text('');
                  return Text(
                    isYearly
                        ? 'T${value + 1}'
                        : (value + 1).toString(),
                    style: const TextStyle(fontSize: 12),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          barGroups: List.generate(
            monthlyData.length,
                (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: monthlyData[index],
                  color: Colors.blue,
                  width: 16,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}