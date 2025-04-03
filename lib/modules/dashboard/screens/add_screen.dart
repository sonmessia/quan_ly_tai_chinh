import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../models/transaction_model.dart';
import '../../../provider/transaction_provider.dart';
import '../../../core/config/constants.dart';
import '../../../core/config/app_styles.dart';
import '../../../services/widgets/custom_widgets.dart';
import '../../../services/transaction_service.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen>
    with SingleTickerProviderStateMixin {
  String _selectedType = 'expense';
  String _selectedCategory = 'shopping';
  String _selectedStatus = 'completed';
  String _selectedPaymentMethod = 'cash';
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _noteController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _saveTransaction() async {
    final double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount.')),
      );
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      final newTransaction = Transaction(
        type: _selectedType,
        categoryName:
            _selectedCategory, // Changed from category to categoryName
        amount: amount,
        paymentMethod: _selectedPaymentMethod,
        status: _selectedStatus,
        date: DateTime.now(),
        note: _noteController.text.trim(),
        userId: 4,
      );

      // Debug print to verify data being sent
      print(
          'Sending transaction data: ${json.encode(newTransaction.toJson())}');

      final addedTransaction =
          await TransactionService.addTransaction(newTransaction);

      if (mounted) {
        Provider.of<TransactionProvider>(context, listen: false)
            .addTransaction(addedTransaction);

        Navigator.pop(context); // Close loading indicator
        Navigator.pop(context); // Go back to previous screen

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction added successfully')),
        );
      }
    } catch (e) {
      print('Error adding transaction: $e');
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add transaction: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text("Add Transaction",
            style: AppStyles.heading.copyWith(color: AppColors.text)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Transaction Type', style: AppStyles.subheading),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AnimatedSelectionCard(
                            isSelected: _selectedType == 'expense',
                            title: 'Expense',
                            icon: Icons.remove_circle_outline,
                            onTap: () => setState(() {
                              _selectedType = 'expense';
                              _selectedCategory =
                                  TransactionIcons.expenseIcons.keys.first;
                            }),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AnimatedSelectionCard(
                            isSelected: _selectedType == 'income',
                            title: 'Income',
                            icon: Icons.add_circle_outline,
                            onTap: () => setState(() {
                              _selectedType = 'income';
                              _selectedCategory =
                                  TransactionIcons.incomeIcons.keys.first;
                            }),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Category', style: AppStyles.subheading),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      childAspectRatio: 0.9,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      children: (_selectedType == 'expense'
                              ? TransactionIcons.expenseIcons
                              : TransactionIcons.incomeIcons)
                          .entries
                          .map((entry) => GestureDetector(
                                onTap: () => setState(
                                    () => _selectedCategory = entry.key),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _selectedCategory == entry.key
                                            ? AppColors.primary.withOpacity(0.1)
                                            : Colors.grey.shade200,
                                      ),
                                      child: Icon(
                                        entry.value,
                                        color: _selectedCategory == entry.key
                                            ? AppColors.primary
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      entry.key,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: _selectedCategory == entry.key
                                            ? AppColors.primary
                                            : AppColors.textSecondary,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Payment Method', style: AppStyles.subheading),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedPaymentMethod,
                      decoration: AppStyles.textFieldDecoration,
                      items: TransactionIcons.paymentMethodIcons.keys
                          .map((String method) => DropdownMenuItem(
                                value: method,
                                child: Row(
                                  children: [
                                    Icon(
                                        TransactionIcons
                                            .paymentMethodIcons[method],
                                        color: AppColors.primary),
                                    const SizedBox(width: 8),
                                    Text(method),
                                  ],
                                ),
                              ))
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _selectedPaymentMethod = val!),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status', style: AppStyles.subheading),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: AppStyles.textFieldDecoration,
                      items: TransactionIcons.statusIcons.keys
                          .map((String status) => DropdownMenuItem(
                                value: status,
                                child: Row(
                                  children: [
                                    Icon(TransactionIcons.statusIcons[status],
                                        color: AppColors.primary),
                                    const SizedBox(width: 8),
                                    Text(status),
                                  ],
                                ),
                              ))
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _selectedStatus = val!),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Amount', style: AppStyles.subheading),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly, // chỉ cho nhập số
                        LengthLimitingTextInputFormatter(
                            10), // giới hạn tối đa 10 chữ số
                      ],
                      decoration: AppStyles.textFieldDecoration.copyWith(
                        hintText: 'Enter amount...',
                        prefixIcon: const Icon(Icons.attach_money_outlined),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Note', style: AppStyles.subheading),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _noteController,
                      decoration: AppStyles.textFieldDecoration.copyWith(
                        hintText: 'Add a note...',
                        prefixIcon: const Icon(Icons.note_add_outlined),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: CustomButton(
                  text: 'Save Transaction',
                  icon: Icons.save_outlined,
                  onPressed: _saveTransaction,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
