import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../models/transaction_model.dart';
import '../../../widgets/chart_card.dart'; // đường dẫn tùy vào vị trí file của bạn

class BarChartWidget extends StatelessWidget {
  final List<Transaction> transactions;
  final String type;

  const BarChartWidget({super.key, required this.transactions, required this.type});

  List<double> _getMonthlyData() {
    final now = DateTime.now();
    List<double> data = List.filled(12, 0);
    for (var t in transactions) {
      if (t.type.toLowerCase() == type.toLowerCase()) {
        final diff = (now.year - t.date.year) * 12 + (now.month - t.date.month);
        if (diff >= 0 && diff < 12) {
          data[11 - diff] += t.amount;
        }
      }
    }
    return data;
  }

  int _getRoundedMax(double value) {
    if (value <= 0) return 1000;
    if (value < 10000) {
      return ((value / 500).ceil()) * 500;
    } else if (value < 1000000) {
      return ((value / 1000).ceil()) * 1000;
    } else {
      return ((value / 1000000).ceil()) * 1000000;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = NumberFormat.decimalPattern('vi_VN');
    final now = DateTime.now();

    final monthlyData = _getMonthlyData();
    final thisMonthTotal = monthlyData.last;
    final lastMonthTotal = monthlyData.length >= 2 ? monthlyData[monthlyData.length - 2] : 0;
    final percentage = lastMonthTotal == 0 ? 0 : ((thisMonthTotal - lastMonthTotal) / lastMonthTotal * 100);
    final maxY = _getRoundedMax(monthlyData.reduce((a, b) => a > b ? a : b));

    final scrollController = ScrollController(initialScrollOffset: 500);

    return Card(
      elevation: 4,
      color: const Color(0xFFF9F4FF),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      shadowColor: Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text("Tổng đã chi tháng này", style: TextStyle(fontSize: 14)),
                const SizedBox(width: 8),
                Icon(
                  percentage < 0 ? Icons.arrow_downward : Icons.arrow_upward,
                  size: 16,
                  color: percentage < 0 ? Colors.green : Colors.red,
                ),
                Text(
                  '${percentage.abs().toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: percentage < 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${formatter.format(thisMonthTotal)} đ',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                height: 220,
                width: 700,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxY.toDouble(),
                    minY: 0,
                    barTouchData: BarTouchData(
                      enabled: true,
                      handleBuiltInTouches: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipRoundedRadius: 10,
                        tooltipPadding: const EdgeInsets.all(8),
                        tooltipMargin: 10,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final monthIndex = (now.month - 11 + group.x) % 12;
                          final year = now.month - 11 + group.x <= 0 ? now.year - 1 : now.year;
                          final label = '${DateFormat.MMM().format(DateTime(0, monthIndex + 1))} $year';

                          return BarTooltipItem(
                            '$label\n${formatter.format(rod.toY)} đ',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 48,
                          getTitlesWidget: (value, meta) {
                            if (value == 0) {
                              return const Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: Text('0', style: TextStyle(fontSize: 10)),
                              );
                            } else if (value == maxY) {
                              final label = value >= 1000000
                                  ? '${(value / 1000000).toStringAsFixed(0)}M'
                                  : '${(value / 1000).toStringAsFixed(0)}K';
                              return Padding(
                                padding: const EdgeInsets.only(left: 6, top: 12),
                                child: Text(label, style: const TextStyle(fontSize: 10)),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            final monthIndex = (now.month - 11 + index) % 12;
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                DateFormat.MMM().format(DateTime(0, monthIndex + 1)),
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: const Border(bottom: BorderSide(color: Colors.grey)),
                    ),
                    barGroups: List.generate(12, (index) {
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: monthlyData[index],
                            width: 18,
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFB388FF),
                                Color(0xFF7C4DFF),
                                Color(0xFF651FFF),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: maxY.toDouble(),
                              color: Colors.grey.shade200,
                            ),
                          ),
                        ],
                      );
                    }),
                    gridData: FlGridData(show: false),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
