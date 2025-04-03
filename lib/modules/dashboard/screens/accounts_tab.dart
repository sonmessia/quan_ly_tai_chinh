import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<AccountData> accounts = [
    AccountData(
      icon: Icons.account_balance_wallet,
      name: 'Cash',
      balance: 500000,
      color: Colors.green,
      recentTransactions: [
        TransactionData(
          title: 'Grocery Shopping',
          amount: -120000,
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        TransactionData(
          title: 'Salary',
          amount: 5000000,
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ],
    ),
    AccountData(
      icon: Icons.account_balance,
      name: 'ACB Bank',
      balance: 3200000,
      color: Colors.blue,
      recentTransactions: [
        TransactionData(
          title: 'Restaurant',
          amount: -250000,
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        TransactionData(
          title: 'Online Transfer',
          amount: 1000000,
          date: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ],
    ),
    AccountData(
      icon: Icons.phone_iphone,
      name: 'Momo Wallet',
      balance: 1500000,
      color: Colors.deepPurple,
      recentTransactions: [
        TransactionData(
          title: 'Movie Tickets',
          amount: -180000,
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
        TransactionData(
          title: 'Transfer from Friend',
          amount: 500000,
          date: DateTime.now().subtract(const Duration(days: 4)),
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double get totalBalance => accounts.fold(0, (sum, acc) => sum + acc.balance);

  void _showAddAccountDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddAccountSheet(),
    );
  }

  void _showAccountDetail(AccountData account) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AccountDetailSheet(account: account),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple.shade50,
        title: Text(
          'Accounts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple.shade700,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.deepPurple.shade700),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Decorative background elements
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepPurple.shade200.withOpacity(0.3),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -80,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepPurple.shade300.withOpacity(0.2),
                ),
              ),
            ),

            // Main content
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Balance Card with Glassmorphism
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurple.shade100.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Balance',
                                    style: TextStyle(
                                      color: Colors.deepPurple.shade300,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.deepPurple.shade100.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'April 2025',
                                      style: TextStyle(
                                        color: Colors.deepPurple.shade700,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${_formatCurrency(totalBalance)} đ',
                                style: TextStyle(
                                  color: Colors.deepPurple.shade700,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildStatCard('Income', '12.5M đ', Icons.arrow_upward, Colors.green.shade600),
                                  _buildStatCard('Expense', '8.2M đ', Icons.arrow_downward, Colors.red.shade600),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Accounts List Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Accounts',
                          style: TextStyle(
                            color: Colors.deepPurple.shade700,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: _showAddAccountDialog,
                          child: Row(
                            children: [
                              Icon(Icons.add, size: 20, color: Colors.deepPurple.shade400),
                              const SizedBox(width: 4),
                              Text(
                                'Add New',
                                style: TextStyle(
                                  color: Colors.deepPurple.shade400,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Accounts List with bottom padding
                  Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: accounts.length,
                      itemBuilder: (context, index) {
                        final account = accounts[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.deepPurple.shade100.withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                  onTap: () => _showAccountDetail(account),
                                  borderRadius: BorderRadius.circular(16),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: account.color.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Icon(account.icon, color: account.color),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    account.name,
                                                    style: TextStyle(
                                                      color: Colors.deepPurple.shade700,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    '${_formatCurrency(account.balance)} đ',
                                                    style: TextStyle(
                                                      color: Colors.deepPurple.shade300,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.more_vert,
                                                color: Colors.deepPurple.shade300,
                                              ),
                                              onPressed: () {
                                                // TODO: Show account options
                                              },
                                            ),
                                          ],
                                        ),
                                        if (account.recentTransactions.isNotEmpty) ...[
                                          Divider(
                                            color: Colors.deepPurple.shade100,
                                            height: 24,
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.access_time,
                                                size: 16,
                                                color: Colors.deepPurple.shade300,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Recent Transaction',
                                                style: TextStyle(
                                                  color: Colors.deepPurple.shade300,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          _buildRecentTransaction(account.recentTransactions.first),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.deepPurple.shade300,
                  fontSize: 12,
                ),
              ),
              Text(
                amount,
                style: TextStyle(
                  color: Colors.deepPurple.shade700,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransaction(TransactionData transaction) {
    final isExpense = transaction.amount < 0;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.title,
                style: TextStyle(
                  color: Colors.deepPurple.shade700,
                  fontSize: 14,
                ),
              ),
              Text(
                DateFormat('MMM dd, yyyy').format(transaction.date),
                style: TextStyle(
                  color: Colors.deepPurple.shade300,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Text(
          '${isExpense ? "-" : "+"} ${_formatCurrency(transaction.amount.abs())} đ',
          style: TextStyle(
            color: isExpense ? Colors.red.shade600 : Colors.green.shade600,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double value) {
    return NumberFormat('#,###', 'vi_VN').format(value);
  }
}

class AddAccountSheet extends StatelessWidget {
  const AddAccountSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.shade100.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add New Account',
            style: TextStyle(
              color: Colors.deepPurple.shade700,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: 'Account Name',
              labelStyle: TextStyle(color: Colors.deepPurple.shade300),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple.shade100),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            style: TextStyle(color: Colors.deepPurple.shade700),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple.shade400,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Add Account'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class AccountDetailSheet extends StatelessWidget {
  final AccountData account;

  const AccountDetailSheet({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.shade100.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: account.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(account.icon, color: account.color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.name,
                      style: TextStyle(
                        color: Colors.deepPurple.shade700,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Balance: ${NumberFormat('#,###', 'vi_VN').format(account.balance)} đ',
                      style: TextStyle(
                        color: Colors.deepPurple.shade300,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(context, Icons.add, 'Add', Colors.green.shade600),
              _buildActionButton(context, Icons.remove, 'Withdraw', Colors.red.shade600),
              _buildActionButton(context, Icons.edit, 'Edit', Colors.blue.shade600),
              _buildActionButton(context, Icons.delete, 'Delete', Colors.red.shade600),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, IconData icon, String label, Color color) {
    return InkWell(
      onTap: () {
        // TODO: Implement actions
        Navigator.pop(context);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.deepPurple.shade300,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class AccountData {
  final IconData icon;
  final String name;
  final double balance;
  final Color color;
  final List<TransactionData> recentTransactions;

  AccountData({
    required this.icon,
    required this.name,
    required this.balance,
    required this.color,
    this.recentTransactions = const [],
  });
}

class TransactionData {
  final String title;
  final double amount;
  final DateTime date;

  TransactionData({
    required this.title,
    required this.amount,
    required this.date,
  });
}