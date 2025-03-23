import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TransactionBarChart extends StatelessWidget {
  final List<double> monthlyData;

  const TransactionBarChart({super.key, required this.monthlyData});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: monthlyData.reduce((value, element) => value > element ? value : element) * 1.5,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const style = TextStyle(
                    color: Color(0xff7589a2),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  );
                  String text;
                  switch (value.toInt()) {
                    case 0:
                      text = 'Jan';
                      break;
                    case 1:
                      text = 'Feb';
                      break;
                    case 2:
                      text = 'Mar';
                      break;
                    case 3:
                      text = 'Apr';
                      break;
                    case 4:
                      text = 'May';
                      break;
                    case 5:
                      text = 'Jun';
                      break;
                    case 6:
                      text = 'Jul';
                      break;
                    case 7:
                      text = 'Aug';
                      break;
                    case 8:
                      text = 'Sep';
                      break;
                    case 9:
                      text = 'Oct';
                      break;
                    case 10:
                      text = 'Nov';
                      break;
                    case 11:
                      text = 'Dec';
                      break;
                    default:
                      text = '';
                  }
                  return Text(text, style: style);
                },
                reservedSize: 38,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: monthlyData
              .asMap()
              .entries
              .map(
                (entry) => BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value,
                  color: Colors.blue,
                ),
              ],
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}