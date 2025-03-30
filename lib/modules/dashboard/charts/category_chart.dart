import 'package:flutter/material.dart';
import 'package:quan_ly_tai_chinh/models/transaction_model.dart';
import 'package:quan_ly_tai_chinh/core/config/constants.dart';

class CategoryChart extends StatelessWidget {
  final List<Transaction> transactions;
  final String type;

  const CategoryChart({super.key, required this.transactions, required this.type});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filtered = transactions.where((t) => t.type.toLowerCase() == type.toLowerCase()).toList();
    final total = filtered.fold(0.0, (sum, t) => sum + t.amount);

    Map<String, double> grouped = {};
    for (var t in filtered) {
      grouped[t.category] = (grouped[t.category] ?? 0) + t.amount;
    }

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thống kê chi tiêu theo danh mục',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (grouped.isEmpty)
              const Center(child: Text("Không có dữ liệu"))
            else
              SizedBox(
                height: 200,
                width: 200,
                child: CustomPaint(
                  painter: Donut3DPainter(color: Colors.blue),
                  child: Center(
                    child: Text(
                      "${(grouped.values.first / total * 100).toStringAsFixed(1)}%",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            if (grouped.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Icon(
                          TransactionIcons.expenseIcons[grouped.keys.first.toLowerCase()] ?? Icons.category,
                          color: Colors.blue,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        grouped.keys.first,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${grouped.values.first.toStringAsFixed(0)} đ',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${(grouped.values.first / total * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(fontSize: 12, color: Colors.redAccent),
                      )
                    ],
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}

class Donut3DPainter extends CustomPainter {
  final Color color;
  Donut3DPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius * 0.6;

    final center = Offset(size.width / 2, size.height / 2);
    final outerPaint = Paint()
      ..shader = LinearGradient(
        colors: [color.withOpacity(0.9), color.withOpacity(0.5)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: outerRadius));

    final innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, outerRadius, outerPaint);
    canvas.drawCircle(center, innerRadius, innerPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
