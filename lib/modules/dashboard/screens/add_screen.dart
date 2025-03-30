import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../../models/transaction_model.dart';
import '../../../provider/transaction_provider.dart';
import '../../transactions/transaction_form.dart';
import '../../../core/config/constants.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  String _selectedType = 'expense';
  String _selectedCategory = 'shopping';
  String _selectedStatus = 'completed';
  String _selectedPaymentMethod = 'cash';
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Transaction",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'expense', label: Text('Expense')),
                ButtonSegment(value: 'income', label: Text('Income')),
              ],
              selected: {_selectedType},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _selectedType = newSelection.first;
                  _selectedCategory = _selectedType == 'expense'
                      ? TransactionIcons.expenseIcons.keys.first
                      : TransactionIcons.incomeIcons.keys.first;
                });
              },
            ),
            const SizedBox(height: 16),

            // Category Dropdown
            _buildDropdownField(
              label: 'Category',
              value: _selectedCategory,
              items: (_selectedType == 'expense'
                  ? TransactionIcons.expenseIcons.keys
                  : TransactionIcons.incomeIcons.keys)
                  .map((String category) => DropdownMenuItem(
                value: category,
                child: Row(
                  children: [
                    Icon(_selectedType == 'expense'
                        ? TransactionIcons.expenseIcons[category]
                        : TransactionIcons.incomeIcons[category]),
                    const SizedBox(width: 8),
                    Text(category),
                  ],
                ),
              ))
                  .toList(),
              onChanged: (val) => setState(() => _selectedCategory = val!),
            ),
            const SizedBox(height: 16),

            _buildDropdownField(
              label: 'Payment Method',
              value: _selectedPaymentMethod,
              items: TransactionIcons.paymentMethodIcons.keys
                  .map((String method) => DropdownMenuItem(
                value: method,
                child: Row(
                  children: [
                    Icon(TransactionIcons.paymentMethodIcons[method]),
                    const SizedBox(width: 8),
                    Text(method),
                  ],
                ),
              ))
                  .toList(),
              onChanged: (val) => setState(() => _selectedPaymentMethod = val!),
            ),
            const SizedBox(height: 16),

            _buildDropdownField(
              label: 'Status',
              value: _selectedStatus,
              items: TransactionIcons.statusIcons.keys
                  .map((String status) => DropdownMenuItem(
                value: status,
                child: Row(
                  children: [
                    Icon(TransactionIcons.statusIcons[status]),
                    const SizedBox(width: 8),
                    Text(status),
                  ],
                ),
              ))
                  .toList(),
              onChanged: (val) => setState(() => _selectedStatus = val!),
            ),
            const SizedBox(height: 16),

            // Preview Card
            TransactionItem(
              type: _selectedType,
              category: _selectedCategory,
              status: _selectedStatus,
              paymentMethod: _selectedPaymentMethod,
              date: DateTime.now(),
              note: _noteController.text,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: const Icon(Icons.category_outlined),
      ),
      items: items,
      onChanged: onChanged,
    );
  }
}
