import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../../../models/transaction_model.dart';
import 'package:collection/collection.dart';

class LineChartWidget extends StatefulWidget {
  final List<Transaction> transactions;
  final String type;

  const LineChartWidget({
    super.key,
    required this.transactions,
    required this.type,
  });

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  bool showAvgLine = false;
  List<Color> gradientColors = [
    const Color(0xFF2196F3),
    const Color(0xFF4CAF50),
  ];

  List<MapEntry<DateTime, double>> _getDailyData(DateTime month) {
    final filtered = widget.transactions
        .where((t) =>
    t.type.toLowerCase() == widget.type.toLowerCase() &&
        t.date.year == month.year &&
        t.date.month == month.month)
        .toList();

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

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('MMMM yyyy').format(currentMonth),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Daily ${widget.type} Overview',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                    // Switch(
                    //   value: showAvgLine,
                    //   onChanged: (value) {
                    //     setState(() {
                    //       showAvgLine = value;
                    //     });
                    //   },
                    //   activeColor: theme.primaryColor,
                    //   activeTrackColor: theme.primaryColor.withOpacity(0.3),
                    // ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _StatCard(
                      title: 'Total',
                      value: NumberFormat('#,###').format(total),
                      color: gradientColors[0],
                      icon: Icons.account_balance_wallet,
                    ),
                    const SizedBox(width: 16),
                    _StatCard(
                      title: 'Average',
                      value: NumberFormat('#,###').format(average),
                      color: gradientColors[1],
                      icon: Icons.trending_up,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      fitInsideHorizontally: true,
                      fitInsideVertically: true,
                      tooltipRoundedRadius: 12,
                      tooltipPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      tooltipBorder: const BorderSide(color: Colors.transparent),
                      tooltipMargin: 8,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final index = spot.spotIndex;
                          final date = dailyData[index].key;
                          final value = NumberFormat('#,###').format(spot.y);
                          return LineTooltipItem(
                            '${DateFormat('dd MMM').format(date)}\n$value đ',
                            TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: '\nđồng',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          );
                        }).toList();
                      },
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: roundedMaxY / 4,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: theme.dividerColor.withOpacity(0.2),
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    ),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        interval: 5,
                        getTitlesWidget: (value, _) {
                          final index = value.toInt();
                          if (index >= 0 && index < dailyData.length) {
                            final date = dailyData[index].key;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                DateFormat('dd').format(date),
                                style: theme.textTheme.bodySmall,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 46,
                        interval: roundedMaxY / 4,
                        getTitlesWidget: (value, _) {
                          return Text(
                            NumberFormat.compact().format(value),
                            style: theme.textTheme.bodySmall,
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      gradient: LinearGradient(colors: gradientColors),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: false,
                        getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                          radius: 4,
                          color: gradientColors[1],
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: gradientColors
                              .map((color) => color.withOpacity(0.2))
                              .toList(),
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    if (showAvgLine)
                      LineChartBarData(
                        spots: List.generate(
                          spots.length,
                              (index) => FlSpot(index.toDouble(), average.toDouble()),
                        ),
                        isCurved: false,
                        color: theme.colorScheme.secondary.withOpacity(0.5),
                        barWidth: 1,
                        dotData: FlDotData(show: false),
                        dashArray: [5, 5],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '$value đ',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}