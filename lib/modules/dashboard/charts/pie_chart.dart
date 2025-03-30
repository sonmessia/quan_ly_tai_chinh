import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../models/transaction_model.dart';
import '../../../core/config/constants.dart';

class PieChartWidget extends StatelessWidget {
  final List<Transaction> transactions;
  final String type;

  const PieChartWidget({super.key, required this.transactions, required this.type});

  Map<String, double> _getCategoryData() {
    final categoryTotals = <String, double>{};
    for (var t in transactions) {
      if (t.type.toLowerCase() == type.toLowerCase()) {
        categoryTotals.update(
          t.category,
              (value) => value + t.amount,
          ifAbsent: () => t.amount,
        );
      }
    }
    return categoryTotals;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = NumberFormat.decimalPattern('vi_VN');
    final categoryData = _getCategoryData();
    final total = categoryData.values.fold(0.0, (a, b) => a + b);

    final colorList = [
      const Color(0xFF7C4DFF),
      const Color(0xFFFF7043),
      const Color(0xFF4DB6AC),
      const Color(0xFFFFCA28),
      const Color(0xFF9575CD),
      const Color(0xFF26A69A),
      const Color(0xFFEF5350),
      const Color(0xFF42A5F5),
    ];

    final entries = categoryData.entries.toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            type.toLowerCase() == 'income'
                ? 'Thống kê thu nhập theo danh mục'
                : 'Thống kê chi tiêu theo danh mục',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          entries.isEmpty
              ? const Center(child: Text("Không có dữ liệu"))
              : Column(
            children: [
              // Pie chart lớn
              SizedBox(
                height: 220,
                child: PieChart(
                  PieChartData(
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                    borderData: FlBorderData(show: false),
                    sections: entries.asMap().entries.map((entry) {
                      final index = entry.key;
                      final e = entry.value;
                      final percentage = total == 0 ? 0 : e.value / total * 100;
                      return PieChartSectionData(
                        value: e.value,
                        color: colorList[index % colorList.length],
                        radius: 80,
                        title: '${percentage.toStringAsFixed(1)}%',
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Tổng: ${formatter.format(total)} đ',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Divider(color: Colors.grey.shade300),
              const SizedBox(height: 8),
              // Danh sách từng danh mục
              ...entries.asMap().entries.map((entry) {
                final index = entry.key;
                final e = entry.value;
                final percentage = total == 0 ? 0 : e.value / total * 100;
                final icon = (type.toLowerCase() == 'income'
                    ? TransactionIcons.incomeIcons
                    : TransactionIcons.expenseIcons)[e.key.toLowerCase()] ??
                    Icons.category;
                final color = colorList[index % colorList.length];

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: color, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.key,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600)),
                            Text('${formatter.format(e.value)} đ',
                                style: const TextStyle(color: Colors.black54, fontSize: 13)),
                          ],
                        ),
                      ),
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }
}
