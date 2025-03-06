import 'package:flutter/material.dart';
import 'package:quan_ly_tai_chinh/appConstants.dart';
class Add extends StatelessWidget {
  Add({super.key});
  AppConstants categories = AppConstants();
  @override
  Widget build(BuildContext context) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Add Transaction'),
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: 'Expense',
                ),
                Tab(
                  text: 'Income',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildTransactionForm(context, isExpense: true),
              _buildTransactionForm(context, isExpense: false),
            ],
          ),
        ),
      );
    }

    Widget _buildTransactionForm(BuildContext context, {required bool isExpense}) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixIcon: Icon(isExpense ? Icons.money_off : Icons.attach_money),
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Description',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: categories
                  .getCategories(isExpense ? "expense" : "income")
                  .map((category) => DropdownMenuItem(
                value: category['name'] as String,
                child: Row(
                  children: [
                    Icon(category['icon'] as IconData),
                    const SizedBox(width: 8),
                    Text(category['name'] as String),
                  ],
                ),
              ))
                  .toList(),
              onChanged: (value) {
                // Handle category selection
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement save transaction
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Save ${isExpense ? 'Expense' : 'Income'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
}
