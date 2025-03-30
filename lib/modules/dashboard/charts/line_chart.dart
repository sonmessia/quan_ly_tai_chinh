import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../../../models/transaction_model.dart';
import 'package:collection/collection.dart';


class LineChartWidget extends StatelessWidget {
  final List<Transaction> transactions;
  final String type;

  const LineChartWidget({
    super.key,
    required this.transactions,
    required this.type,
  });

  List<MapEntry<DateTime, double>> _getDailyData(DateTime month) {
    final filtered = transactions.where((t) =>
    t.type.toLowerCase() == type.toLowerCase() &&
        t.date.year == month.year &&
        t.date.month == month.month).toList();

    final dailyTotals = <DateTime, double>{};
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    for (int i = 1; i <= daysInMonth; i++) {
      dailyTotals[DateTime(month.year, month.month, i)] = 0;
    }

    for (var t in filtered) {
      final date = DateTime(t.date.year, t.date.month, t.date.day);
      dailyTotals.update(date, (value) => value + t.amount);
    }

    return dailyTotals.entries.toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final DateTime currentMonth = DateTime.now();
    final dailyData = _getDailyData(currentMonth);

    final total = dailyData.fold(0.0, (sum, e) => sum + e.value);
    final average = dailyData.isNotEmpty ? (total / dailyData.length) : 0;
    final maxY = dailyData.map((e) => e.value).fold(0.0, max);
    final roundedMaxY = (maxY == 0) ? 100 : ((maxY / 100).ceil() * 100).toDouble();

    final spots = dailyData.mapIndexed((i, e) => FlSpot(i.toDouble(), e.value)).toList();

    final dotColors = [Colors.red, Colors.orange, Colors.green, Colors.blue, Colors.purple];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total: ${NumberFormat('#,###').format(total)}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('Average: ${NumberFormat('#,###').format(average)}',
              style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: roundedMaxY.toDouble(),
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipMargin: 8,
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final index = spot.spotIndex;
                        final date = dailyData[index].key;
                        final value = NumberFormat('#,###').format(spot.y);
                        return LineTooltipItem(
                          '${DateFormat('dd MMM').format(date)}\n$value đ',
                          const TextStyle(color: Colors.black),
                        );
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.15),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: 1,
                      getTitlesWidget: (value, _) {
                        final day = value.toInt() + 1;
                        if ([0, 7, 14, 21, 28].contains(value.toInt())) {
                          if (value == 0) {
                            final month = DateFormat('MMM').format(currentMonth);
                            return Text('$month\n$day',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 10));
                          }
                          return Text('$day', style: const TextStyle(fontSize: 10));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: roundedMaxY.toDouble(),
                      getTitlesWidget: (value, _) {
                        if (value == 0 || value == roundedMaxY) {
                          return Text(
                            NumberFormat('#,###').format(value),
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    left: BorderSide(color: Colors.grey.shade300, width: 1),
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: theme.colorScheme.primary,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: dotColors[index % dotColors.length],
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.2),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
