import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/transaction_model.dart';

class TransactionDetailScreen extends StatefulWidget {
  final Transaction transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  State<TransactionDetailScreen> createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  bool _isEditing = false;
  late TextEditingController _amountController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.transaction.amount.toString());
    _noteController = TextEditingController(text: widget.transaction.note ?? '');
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() => _isEditing = !_isEditing);
  }

  void _deleteTransaction() {
    // TODO: Connect with provider
    Navigator.pop(context);
  }

  void _saveChanges() {
    // TODO: Update transaction with provider
    setState(() => _isEditing = false);
  }

  Widget _buildDetailRow(String label, Widget valueWidget) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: valueWidget),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transaction = widget.transaction;
    final theme = Theme.of(context);
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.edit, color: Colors.black),
                          title: const Text('Edit'),
                          onTap: () {
                            Navigator.pop(context);
                            _toggleEdit();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete, color: Colors.red),
                          title: const Text('Delete'),
                          onTap: () {
                            Navigator.pop(context);
                            _deleteTransaction();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.more_vert, color: Colors.black),
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Type', Text(transaction.type)),
            _buildDetailRow('Category', Text(transaction.category)),
            _buildDetailRow(
              'Amount',
              _isEditing
                  ? TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
              )
                  : Text(formatter.format(transaction.amount)),
            ),
            _buildDetailRow('Status', Text(transaction.status)),
            _buildDetailRow('Payment Method', Text(transaction.paymentMethod)),
            _buildDetailRow('Date', Text(DateFormat('dd/MM/yyyy').format(transaction.date))),
            _buildDetailRow(
              'Note',
              _isEditing
                  ? TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
              )
                  : Text(transaction.note ?? '-', style: const TextStyle(color: Colors.black87)),
            ),
            const SizedBox(height: 24),
            if (_isEditing)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Save Changes'),
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
