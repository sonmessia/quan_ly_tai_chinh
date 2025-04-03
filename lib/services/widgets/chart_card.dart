import 'package:flutter/material.dart';

Widget buildChartCard({required Widget child}) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: child,
    ),
  );
}

