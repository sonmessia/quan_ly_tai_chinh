import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TransactionPieChart extends StatelessWidget {
  final List<PieData> data;

  const TransactionPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.2,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: data.map((item) {
                final isHighlighted = item.value > 25; // làm nổi bật nếu lớn hơn 25%
                return PieChartSectionData(
                  color: item.color,
                  value: item.value,
                  title: '${item.title}\n${item.value.toStringAsFixed(1)}%',
                  radius: isHighlighted ? 60 : 50,
                  titleStyle: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: isHighlighted ? 14 : 12,
                  ),
                );
              }).toList(),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Legend
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: data.map((item) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: item.color,
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  item.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black87,
                  ),
                ),
              ],
            );
          }).toList(),
        )
      ],
    );
  }
}

class PieData {
  final String title;
  final double value;
  final Color color;

  PieData({
    required this.title,
    required this.value,
    required this.color,
  });
}
