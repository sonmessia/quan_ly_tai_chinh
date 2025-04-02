import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../models/transaction_model.dart';
import '../../../core/config/constants.dart';

class PieChartWidget extends StatefulWidget {
  final List<Transaction> transactions;
  final String type;

  const PieChartWidget({
    super.key,
    required this.transactions,
    required this.type,
  });

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> with SingleTickerProviderStateMixin {
  int? touchedIndex;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<Color> colorList = [
    const Color(0xFF6200EA), // Deep Purple
    const Color(0xFFFF6D00), // Orange
    const Color(0xFF2962FF), // Blue
    const Color(0xFF00C853), // Green
    const Color(0xFFAA00FF), // Purple
    const Color(0xFFFFAB00), // Amber
    const Color(0xFFD50000), // Red
    const Color(0xFF00B8D4), // Cyan
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Map<String, double> _getCategoryData() {
    final categoryTotals = <String, double>{};
    for (var t in widget.transactions) {
      if (t.type.toLowerCase() == widget.type.toLowerCase()) {
        categoryTotals.update(
          t.category,
              (value) => value + t.amount,
          ifAbsent: () => t.amount,
        );
      }
    }
    return categoryTotals;
  }

// Giữ nguyên phần import và class declaration

// Trong _PieChartWidgetState, thay đổi phần build:
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = NumberFormat('#,###', 'vi_VN');
    final categoryData = _getCategoryData();
    final total = categoryData.values.fold(0.0, (a, b) => a + b);
    final entries = categoryData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 16),
      // Thêm margin-top để tách với LineChart
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
                  widget.type.toLowerCase() == 'income'
                      ? 'Income Categories'
                      : 'Expense Categories',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total: ${formatter.format(total)} đ',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (entries.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text("No data available"),
              ),
            )
          else
            Column(
              children: [
                SizedBox(
                  height: 240,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    // Thêm padding bên trái
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2, // Điều chỉnh tỷ lệ để pie chart nhỏ hơn
                          child: AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return PieChart(
                                PieChartData(
                                  pieTouchData: PieTouchData(
                                    touchCallback: (FlTouchEvent event,
                                        pieTouchResponse) {
                                      setState(() {
                                        if (!event
                                            .isInterestedForInteractions ||
                                            pieTouchResponse == null ||
                                            pieTouchResponse.touchedSection ==
                                                null) {
                                          touchedIndex = -1;
                                          return;
                                        }
                                        touchedIndex =
                                            pieTouchResponse.touchedSection!
                                                .touchedSectionIndex;
                                      });
                                    },
                                  ),
                                  startDegreeOffset: -90,
                                  sectionsSpace: 2,
                                  centerSpaceRadius: 40,
                                  // Giảm kích thước lỗ giữa
                                  sections: _generateSections(entries, total),
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: entries.length,
                            padding: const EdgeInsets.only(left: 16, right: 20),
                            itemBuilder: (context, index) {
                              final entry = entries[index];
                              final color = colorList[index % colorList.length];
                              final percentage = total == 0 ? 0 : (entry.value /
                                  total * 100);

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4),
                                child: _Indicator(
                                  color: color,
                                  text: entry.key,
                                  percentage: percentage.toDouble(),
                                  isSelected: touchedIndex == index,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16), // Thêm khoảng cách trước divider
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(),
                ),
                const SizedBox(height: 8), // Thêm khoảng cách sau divider
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: entries.length,
                  padding: const EdgeInsets.all(20),
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    final color = colorList[index % colorList.length];
                    final percentage = total == 0 ? 0 : (entry.value / total *
                        100);
                    final icon = (widget.type.toLowerCase() == 'income'
                        ? TransactionIcons.incomeIcons
                        : TransactionIcons.expenseIcons)[entry.key
                        .toLowerCase()] ??
                        Icons.category;

                    return _CategoryItem(
                      icon: icon,
                      color: color,
                      name: entry.key,
                      amount: entry.value,
                      percentage: percentage.toDouble(),
                      isSelected: touchedIndex == index,
                      onTap: () {
                        setState(() {
                          touchedIndex = touchedIndex == index ? -1 : index;
                        });
                      },
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _generateSections(
      List<MapEntry<String, double>> entries,
      double total,) {
    return entries
        .asMap()
        .entries
        .map((entry) {
      final index = entry.key;
      final data = entry.value;
      final percentage = total == 0 ? 0 : (data.value / total * 100);
      final isTouched = index == touchedIndex;
      final radius = isTouched ? 80.0 : 70.0; // Giảm kích thước radius

      return PieChartSectionData(
        color: colorList[index % colorList.length],
        value: data.value,
        title: percentage >= 5 ? '${percentage.toStringAsFixed(1)}%' : '',
        radius: radius * _animation.value,
        titleStyle: TextStyle(
          fontSize: isTouched ? 14 : 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}
class _Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final double percentage;
  final bool isSelected;

  const _Indicator({
    required this.color,
    required this.text,
    required this.percentage,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? color : color.withOpacity(0.6),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? Theme.of(context).textTheme.bodyLarge?.color
                  : Theme.of(context).textTheme.bodySmall?.color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String name;
  final double amount;
  final double percentage;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.icon,
    required this.color,
    required this.name,
    required this.amount,
    required this.percentage,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${NumberFormat('#,###', 'vi_VN').format(amount)} đ',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}