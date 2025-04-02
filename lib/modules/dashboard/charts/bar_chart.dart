import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../models/transaction_model.dart';
import 'dart:ui' as ui;


class BarChartWidget extends StatefulWidget {
  final List<Transaction> transactions;
  final String type;

  const BarChartWidget({
    super.key,
    required this.transactions,
    required this.type,
  });

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int? touchedIndex;
  bool isScrolledToEnd = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  double _calculateLabelWidth(BuildContext context, double maxY) {
    final text = _formatMoney(maxY); // ví dụ "103.0K"
    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: text,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();

    return painter.width + 20; // thêm padding trái/phải
  }


  List<double> _getMonthlyData() {
    final now = DateTime.now();
    List<double> data = List.filled(12, 0);
    for (var t in widget.transactions) {
      if (t.type.toLowerCase() == widget.type.toLowerCase()) {
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

  String _formatMoney(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K'; // ✅ Giữ 1 số lẻ để tránh trùng
    }
    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = NumberFormat('#,###', 'vi_VN');
    final now = DateTime.now();
    final monthlyData = _getMonthlyData();
    final thisMonthTotal = monthlyData.last;
    final lastMonthTotal = monthlyData.length >= 2 ? monthlyData[monthlyData.length - 2] : 0;
    final percentage = lastMonthTotal == 0 ? 0 : ((thisMonthTotal - lastMonthTotal) / lastMonthTotal * 100);
    final maxY = _getRoundedMax(monthlyData.reduce((a, b) => a > b ? a : b));

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
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
                Text(
                  widget.type == 'income' ? 'Monthly Income' : 'Monthly Expenses',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Last 12 months overview',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: theme.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'This Month',
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          if (percentage != 0) ...[
                            Icon(
                              percentage < 0 ? Icons.arrow_downward : Icons.arrow_upward,
                              size: 16,
                              color: percentage < 0 ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${percentage.abs().toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: percentage < 0 ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${formatter.format(thisMonthTotal)} đ',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 340,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 16, 32),
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: max(MediaQuery.of(context).size.width - 32, 700),
                  child: BarChart(
                    BarChartData(
                      maxY: maxY.toDouble(),
                      minY: 0,
                      barTouchData: BarTouchData(
                        enabled: true,
                        handleBuiltInTouches: true,
                        touchTooltipData: BarTouchTooltipData(
                          fitInsideHorizontally: true,
                          fitInsideVertically: true,
                          tooltipRoundedRadius: 8,
                          tooltipPadding: const EdgeInsets.all(12),
                          tooltipMargin: 8,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final monthIndex = (now.month - 11 + group.x.toInt()) % 12;
                            final year = now.month - 11 + group.x.toInt() <= 0
                                ? now.year - 1
                                : now.year;
                            return BarTooltipItem(
                              '${DateFormat.MMMM().format(DateTime(year, monthIndex + 1))}\n${formatter.format(rod.toY)} đ',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 20, // 👈 giúp đẩy biểu đồ xuống để không che số trên
                            getTitlesWidget: (value, meta) => const SizedBox.shrink(), // nếu không cần hiện gì trên top
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: _calculateLabelWidth(context, maxY.toDouble()),
                            interval: maxY / 5,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  _formatMoney(value),
                                  style: theme.textTheme.bodySmall,
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 36,
                            getTitlesWidget: (value, meta) {
                              final monthIndex = (now.month - 11 + value.toInt()) % 12;
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  DateFormat.MMM().format(DateTime(0, monthIndex + 1)),
                                  style: theme.textTheme.bodySmall,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: maxY / 5,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: theme.dividerColor.withOpacity(0.2),
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(12, (index) {
                        final isCurrent = index == 11;
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: monthlyData[index] * _animation.value,
                              width: 18,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                              gradient: LinearGradient(
                                colors: isCurrent ? [
                                  theme.primaryColor,
                                  theme.primaryColor.withOpacity(0.7),
                                ] : [
                                  const Color(0xFFB388FF),
                                  const Color(0xFF7C4DFF),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: maxY.toDouble(),
                                color: theme.dividerColor.withOpacity(0.1),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}