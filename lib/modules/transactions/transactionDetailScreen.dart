import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../models/transaction_model.dart';
import '../../../provider/transaction_provider.dart';

class TransactionDetailScreen extends StatefulWidget {
  Transaction transaction;  // Changed to non-final for updates

  TransactionDetailScreen({super.key, required this.transaction});

  @override
  State<TransactionDetailScreen> createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> with SingleTickerProviderStateMixin {
  bool _isEditing = false;
  late TextEditingController _amountController;
  late TextEditingController _noteController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.transaction.amount.toString());
    _noteController = TextEditingController(text: widget.transaction.note ?? '');
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() => _isEditing = !_isEditing);
    if (_isEditing) {
      _animationController.forward(from: 0.0);
    }
  }

  void _deleteTransaction() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.warning_rounded, color: Colors.red.shade400),
            ),
            const SizedBox(width: 16),
            const Text(
              'Delete Transaction',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete this transaction?',
          style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.deepPurple.shade300,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<TransactionProvider>(context, listen: false)
                  .deleteTransaction(widget.transaction);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _saveChanges() {
    final newAmount = double.tryParse(_amountController.text) ?? widget.transaction.amount;
    final newTransaction = Transaction(
      type: widget.transaction.type,
      category: widget.transaction.category,
      amount: newAmount,
      status: widget.transaction.status,
      paymentMethod: widget.transaction.paymentMethod,
      date: widget.transaction.date,
      note: _noteController.text.trim(),
    );

    Provider.of<TransactionProvider>(context, listen: false)
        .updateTransaction(widget.transaction, newTransaction);

    setState(() {
      widget.transaction = newTransaction;
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green.shade100),
            const SizedBox(width: 12),
            const Text('Changes saved successfully'),
          ],
        ),
        backgroundColor: Colors.deepPurple.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
  Widget _buildHeader(Transaction transaction) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.deepPurple.shade300,
            Colors.deepPurple.shade500,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaction Details',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('dd MMMM yyyy').format(transaction.date),
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailSection(
              'Amount',
              NumberFormat.currency(locale: 'vi_VN', symbol: 'đ')
                  .format(widget.transaction.amount),
              widget.transaction.type == 'income'
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              widget.transaction.type == 'income'
                  ? Colors.green
                  : Colors.red,
            ),
            _buildDivider(),
            _buildDetailSection(
              'Category',
              widget.transaction.category,
              Icons.category_rounded,
              Colors.deepPurple.shade400,
            ),
            _buildDivider(),
            _buildDetailSection(
              'Payment Method',
              widget.transaction.paymentMethod,
              Icons.payment_rounded,
              Colors.deepPurple.shade400,
            ),
            _buildDivider(),
            _buildDetailSection(
              'Status',
              widget.transaction.status,
              Icons.check_circle_outline_rounded,
              Colors.deepPurple.shade400,
            ),
            _buildDivider(),
            _buildDetailSection(
              'Date & Time',
              DateFormat('dd MMMM yyyy, HH:mm').format(widget.transaction.date),
              Icons.access_time_rounded,
              Colors.deepPurple.shade400,
            ),
            if (widget.transaction.note?.isNotEmpty ?? false) ...[
              _buildDivider(),
              _buildDetailSection(
                'Note',
                widget.transaction.note!,
                Icons.note_rounded,
                Colors.deepPurple.shade400,
              ),
            ],
            if (_isEditing) ...[
              _buildDivider(),
              FadeTransition(
                opacity: _fadeAnimation,
                child: _buildEditableFields(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(color: Colors.grey.shade200),
    );
  }

  Widget _buildEditableFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Edit Amount',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.deepPurple.shade400),
            ),
            prefixIcon: Icon(
              Icons.monetization_on_rounded,
              color: Colors.deepPurple.shade400,
            ),
            isDense: true,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Edit Note',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _noteController,
          maxLines: 3,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.deepPurple.shade400),
            ),
            prefixIcon: Icon(
              Icons.note_rounded,
              color: Colors.deepPurple.shade400,
            ),
            isDense: true,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade400,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit_rounded, color: Colors.white),
              onPressed: _toggleEdit,
            ),
          IconButton(
            icon: const Icon(Icons.delete_rounded, color: Colors.white),
            onPressed: _deleteTransaction,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(widget.transaction),
            _buildDetailCard(),
          ],
        ),
      ),
      bottomNavigationBar: _isEditing
          ? Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _toggleEdit,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.deepPurple.shade400,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
          : null,
    );
  }
}