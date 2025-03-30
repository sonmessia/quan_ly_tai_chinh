import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:collection/collection.dart';
import '../../../models/transaction_model.dart';

class LineChartWidget extends StatelessWidget {
  final List<Transaction> transactions;
  final String type;

  const LineChartWidget({
    super.key,
    required this.transactions,
    required this.type,
  });

  List<FlSpot> _getDailyData() {
    if (transactions.isEmpty) return [FlSpot(0, 0)];

    final filtered =
    transactions.where((t) => t.type.toLowerCase() == type.toLowerCase()).toList();
    final sorted = [...filtered]..sort((a, b) => a.date.compareTo(b.date));
    final dailyTotals = <DateTime, double>{};

    for (var t in sorted) {
      final date = DateTime(t.date.year, t.date.month, t.date.day);
      dailyTotals.update(date, (v) => v + t.amount, ifAbsent: () => t.amount);
    }

    return dailyTotals.entries.mapIndexed((i, e) => FlSpot(i.toDouble(), e.value)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final data = _getDailyData();
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F4FF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type.toLowerCase() == 'income'
                ? 'Biến động thu nhập'
                : 'Biến động chi tiêu',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (data.isEmpty || (data.length == 1 && data[0].y == 0))
            const Center(
              child: Text(
                'Không có giao dịch để hiển thị',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.1),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data,
                      isCurved: true,
                      color: theme.colorScheme.primary,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary.withOpacity(0.4),
                            theme.colorScheme.primary.withOpacity(0.05),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
