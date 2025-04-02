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

class _BarChartWidgetState extends State<BarChartWidget>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isFirstBuild = true;

  @override
  bool get wantKeepAlive => true;

  void _scrollToCurrentMonth() {
    if (_scrollController.hasClients) {
      final screenWidth = MediaQuery.of(context).size.width;
      final chartWidth = max(screenWidth - 32, 700.0);
      final barWidth = chartWidth / 12;

      _scrollController.animateTo(
        chartWidth - screenWidth + 32,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _initializeAnimation();

    _scrollController.addListener(() {
      setState(() {}); // Để cập nhật UI khi scroll
    });
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );

    _animation.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstBuild) {
      _isFirstBuild = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startAnimation();
        _scrollToCurrentMonth();
      });
    }
  }

  void _startAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  void _handleTabChange() {
    _startAnimation();

    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToCurrentMonth();
    });
  }

  @override
  void didUpdateWidget(BarChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.transactions != widget.transactions ||
        oldWidget.type != widget.type) {
      _handleTabChange();
    }
  }

  @override
  void dispose() {
    _animation.removeListener(() {});
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  double _calculateLabelWidth(BuildContext context, double maxY) {
    final text = _formatMoney(maxY);
    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: text,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();

    return painter.width + 20;
  }

  List<double> _getMonthlyData() {
    final now = DateTime.now();
    List<double> data = List.filled(12, 0);

    final currentMonth = DateTime(now.year, now.month);
    final startMonth = DateTime(currentMonth.year, currentMonth.month - 11);

    for (var t in widget.transactions) {
      if (t.type.toLowerCase() == widget.type.toLowerCase()) {
        final transactionDate = DateTime(t.date.year, t.date.month);
        if (transactionDate.isAfter(startMonth.subtract(const Duration(days: 1))) &&
            transactionDate.isBefore(currentMonth.add(const Duration(days: 1)))) {

          final monthDiff = (currentMonth.year - transactionDate.year) * 12 +
              (currentMonth.month - transactionDate.month);
          final index = 11 - monthDiff;

          if (index >= 0 && index < 12) {
            data[index] += t.amount;
          }
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
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final formatter = NumberFormat('#,###', 'vi_VN');
    final now = DateTime.now();
    final monthlyData = _getMonthlyData();

    bool hasData = monthlyData.any((amount) => amount > 0);

    if (!hasData) {
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'No data available for the last 12 months',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          ),
        ),
      );
    }

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
                physics: const BouncingScrollPhysics(),
                clipBehavior: Clip.none,
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
                            final currentMonth = DateTime(now.year, now.month);
                            final monthDate = DateTime(
                                currentMonth.year,
                                currentMonth.month - (11 - group.x.toInt())
                            );
                            return BarTooltipItem(
                              '${DateFormat.MMMM().format(monthDate)}\n${formatter.format(rod.toY)} đ',
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
                            reservedSize: 20,
                            getTitlesWidget: (value, meta) => const SizedBox.shrink(),
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
                              final currentMonth = DateTime(now.year, now.month);
                              final monthDate = DateTime(
                                  currentMonth.year,
                                  currentMonth.month - (11 - value.toInt())
                              );
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  DateFormat.MMM().format(monthDate),
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