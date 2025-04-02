import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  final List<AccountData> accounts = [
    AccountData(icon: Icons.account_balance_wallet, name: 'Cash', balance: 500000),
    AccountData(icon: Icons.account_balance, name: 'ACB Bank', balance: 3200000),
    AccountData(icon: Icons.phone_iphone, name: 'Momo Wallet', balance: 1500000),
  ];

  AccountScreen({super.key});

  double get totalBalance => accounts.fold(0, (sum, acc) => sum + acc.balance);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Accounts'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Balance',
                        style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey)),
                    const SizedBox(height: 8),
                    Text('${_formatCurrency(totalBalance)} đ',
                        style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Your Accounts', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: accounts.length,
                itemBuilder: (context, index) {
                  final account = accounts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.primaryColor.withOpacity(0.1),
                        child: Icon(account.icon, color: theme.primaryColor),
                      ),
                      title: Text(account.name),
                      trailing: Text('${_formatCurrency(account.balance)} đ',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Chuyển tới màn hình thêm tài khoản
              },
              icon: const Icon(Icons.add),
              label: const Text('Add New Account'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
  }
}

class AccountData {
  final IconData icon;
  final String name;
  final double balance;

  AccountData({required this.icon, required this.name, required this.balance});
}
