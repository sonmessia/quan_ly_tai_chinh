import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../models/transaction_model.dart';
import '../../../provider/transaction_provider.dart';
import '../../../core/config/constants.dart';
import '../../transactions/transactionDetailScreen.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  late DateTime selectedDate;
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  void _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      helpText: 'Chọn ngày muốn lọc',
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _clearFilters() {
    setState(() {
      selectedDate = DateTime.now();
      searchQuery = "";
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.transactions;

    final filtered = transactions.where((t) {
      final matchesDate = t.date.year == selectedDate.year &&
          t.date.month == selectedDate.month &&
          t.date.day == selectedDate.day;

      final matchesSearch = searchQuery.isEmpty ||
          t.category.toLowerCase().contains(searchQuery.toLowerCase()) ||
          t.type.toLowerCase().contains(searchQuery.toLowerCase()) ||
          t.paymentMethod.toLowerCase().contains(searchQuery.toLowerCase()) ||
          t.status.toLowerCase().contains(searchQuery.toLowerCase()) ||
          t.note?.toLowerCase().contains(searchQuery.toLowerCase()) == true ||
          t.amount.toString().contains(searchQuery);

      return matchesDate && matchesSearch;
    }).toList();

    final incomeTotal = filtered.where((t) => t.type == 'income').fold(0.0, (sum, t) => sum + t.amount);
    final expenseTotal = filtered.where((t) => t.type == 'expense').fold(0.0, (sum, t) => sum + t.amount);
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
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
            ListTile(leading: Icon(Icons.bar_chart), title: Text('Statistics')),
            ListTile(leading: Icon(Icons.info_outline), title: Text('About')),
            ListTile(leading: Icon(Icons.logout), title: Text('Logout')),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
          onChanged: (value) => setState(() => searchQuery = value),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined, color: Colors.black),
            onPressed: () => _pickDate(context),
          ),
          IconButton(
            icon: const Icon(Icons.clear, color: Colors.black),
            tooltip: 'Xóa bộ lọc',
            onPressed: _clearFilters,
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
                  DateFormat('dd/MM/yyyy').format(selectedDate),
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
                      child: Text(
                        '$label  •  $weekday',
                        style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...txs.map((t) {
                      final isIncome = t.type == 'income';
                      final icon = isIncome
                          ? TransactionIcons.incomeIcons[t.category.toLowerCase()]
                          : TransactionIcons.expenseIcons[t.category.toLowerCase()];

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TransactionDetailScreen(transaction: t),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey.shade100,
                            child: Icon(icon ?? Icons.category, color: Colors.cyan),
                          ),
                          title: Text(t.category,
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                          subtitle: Text(DateFormat('MMM d, yyyy').format(t.date),
                              style: const TextStyle(color: Colors.black45)),
                          trailing: Text(
                            (isIncome ? '+' : '-') + NumberFormat('#,###').format(t.amount),
                            style: TextStyle(
                              color: isIncome ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
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
