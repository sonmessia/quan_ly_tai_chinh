import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../models/transaction_model.dart';
import '../../../provider/transaction_provider.dart';
import '../../../core/config/constants.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  late DateTime selectedMonth;

  @override
  void initState() {
    super.initState();
    selectedMonth = DateTime.now();
  }

  void _pickMonth(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedMonth,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'Chọn tháng hiển thị',
    );

    if (picked != null) {
      setState(() => selectedMonth = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.transactions;
    final formatter = DateFormat('MMMM yyyy');

    final filtered = transactions.where((t) =>
    t.date.year == selectedMonth.year &&
        t.date.month == selectedMonth.month).toList();

    final incomeTotal = filtered
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);
    final expenseTotal = filtered
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);
    final balance = incomeTotal - expenseTotal;

    final grouped = <String, List<Transaction>>{};
    for (var t in filtered) {
      final key = DateFormat('yyyy-MM-dd').format(t.date);
      grouped.putIfAbsent(key, () => []).add(t);
    }
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: ListView(
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
            ListTile(leading: Icon(Icons.info), title: Text('About')),
            ListTile(leading: Icon(Icons.logout), title: Text('Logout')),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text('Money Tracker', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined, color: Colors.black),
            onPressed: () => _pickMonth(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatter.format(selectedMonth),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _summaryBlock('Expenses', expenseTotal, Colors.red),
                    _summaryBlock('Income', incomeTotal, Colors.green),
                    _summaryBlock('Balance', balance, Colors.black),
                  ],
                ),
              ],
            ),
          ),
          const Divider(thickness: 1),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text("No transactions", style: TextStyle(color: Colors.black54)))
                : ListView.builder(
              itemCount: sortedKeys.length,
              itemBuilder: (context, index) {
                final dateKey = sortedKeys[index];
                final date = DateTime.parse(dateKey);
                final txs = grouped[dateKey]!;
                final label = DateFormat('MMM d').format(date);
                final weekday = DateFormat('EEEE').format(date);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 12, bottom: 4),
                      child: Text('$label  •  $weekday', style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                    ),
                    ...txs.map((t) {
                      final isIncome = t.type == 'income';
                      final icon = isIncome
                          ? TransactionIcons.incomeIcons[t.category.toLowerCase()]
                          : TransactionIcons.expenseIcons[t.category.toLowerCase()];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.shade100,
                          child: Icon(icon ?? Icons.category, color: Colors.cyan),
                        ),
                        title: Text(t.category, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                        subtitle: Text(DateFormat('MMM d, yyyy').format(t.date), style: const TextStyle(color: Colors.black45)),
                        trailing: Text(
                          (isIncome ? '+' : '-') + NumberFormat('#,###').format(t.amount),
                          style: TextStyle(
                            color: isIncome ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryBlock(String label, double amount, Color color) {
    return Flexible(
      fit: FlexFit.tight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black45)),
          const SizedBox(height: 4),
          FittedBox(
            child: Text(
              NumberFormat('#,###').format(amount),
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
