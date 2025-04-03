import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_chinh/modules/auth/auth_controller.dart';
import 'package:quan_ly_tai_chinh/modules/dashboard/screens/add_screen.dart';
import 'package:quan_ly_tai_chinh/services/transaction_service.dart';
import 'dart:ui';
import '../../../models/transaction_model.dart';
import '../../../provider/transaction_provider.dart';
import '../../../core/config/constants.dart';
import '../../transactions/transactionDetailScreen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen>
    with SingleTickerProviderStateMixin {
  late DateTime selectedDate;
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  String searchQuery = "";
  List<Transaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      setState(() => _isLoading = true);

      final userId = AuthController.instance.currentUser?.id;
      if (userId == null) {
        print('Error: User ID is null');
        return;
      }

      final transactions =
          await TransactionService.getTransactionsByUserId(userId);
      print('Fetched ${transactions.length} transactions'); // Debug print

      // Update the provider with fetched transactions
      if (mounted) {
        Provider.of<TransactionProvider>(context, listen: false)
            .setTransactions(transactions);
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading transactions: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      helpText: 'Chọn ngày muốn lọc',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepPurple.shade400,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
      _animationController.forward(from: 0.0);
    }
  }

  void _clearFilters() {
    setState(() {
      selectedDate = DateTime.now();
      searchQuery = "";
      _searchController.clear();
    });
    _animationController.forward(from: 0.0);
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade50,
              Colors.white,
            ],
          ),
        ),
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.deepPurple.shade400,
                    Colors.deepPurple.shade200,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 35,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Financial Manager',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Welcome back!',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.dashboard_rounded, 'Dashboard'),
            _buildDrawerItem(Icons.bar_chart_rounded, 'Statistics'),
            _buildDrawerItem(Icons.settings_rounded, 'Settings'),
            _buildDrawerItem(Icons.help_outline_rounded, 'Help & Support'),
            const Divider(),
            _buildDrawerItem(Icons.logout_rounded, 'Logout'),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple.shade400),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.deepPurple.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        // Handle drawer item tap
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        final transactions = transactionProvider.transactions;
        print(
            'Building with ${transactions.length} transactions'); // Debug print

        final filtered = transactions.where((t) {
          final matchesDate = t.date.year == selectedDate.year &&
              t.date.month == selectedDate.month &&
              t.date.day == selectedDate.day;

          final matchesSearch = searchQuery.isEmpty ||
              t.category.toLowerCase().contains(searchQuery.toLowerCase()) ||
              t.type.toLowerCase().contains(searchQuery.toLowerCase()) ||
              t.paymentMethod
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              t.status.toLowerCase().contains(searchQuery.toLowerCase()) ||
              t.note?.toLowerCase().contains(searchQuery.toLowerCase()) ==
                  true ||
              t.amount.toString().contains(searchQuery);

          return matchesDate && matchesSearch;
        }).toList();

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
        final sortedKeys = grouped.keys.toList()
          ..sort((a, b) => b.compareTo(a));

        return Scaffold(
          backgroundColor: Colors.deepPurple.shade50,
          drawer: _buildDrawer(),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                expandedHeight: 140,
                floating: true,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.deepPurple.shade100,
                          Colors.deepPurple.shade50,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      decoration: const InputDecoration(
                                        hintText: 'Search transactions...',
                                        border: InputBorder.none,
                                        icon: Icon(Icons.search),
                                      ),
                                      onChanged: (value) =>
                                          setState(() => searchQuery = value),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                        Icons.calendar_month_outlined),
                                    onPressed: () => _pickDate(context),
                                    color: Colors.deepPurple.shade400,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: _clearFilters,
                                    color: Colors.deepPurple.shade400,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            body: Column(
              children: [
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.shade100.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('dd MMMM yyyy').format(selectedDate),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple.shade700,
                                ),
                              ),
                              Icon(Icons.calendar_today,
                                  color: Colors.deepPurple.shade400, size: 20),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: [
                              _buildSummaryCard(
                                  'Income', incomeTotal, Colors.green),
                              const SizedBox(
                                  height: 8), // Khoảng cách giữa các card
                              _buildSummaryCard(
                                  'Expense', expenseTotal, Colors.red),
                              const SizedBox(height: 8),
                              _buildSummaryCard('Balance', balance,
                                  Colors.deepPurple.shade700),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                // THÊM DIVIDER VÀO ĐÂY - giữa AnimatedBuilder và Expanded
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Hiệu ứng đường viền kép
                      Column(
                        children: [
                          Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.deepPurple.shade50,
                                  Colors.deepPurple.shade200,
                                  Colors.deepPurple.shade50,
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.deepPurple.shade50,
                                  Colors.deepPurple.shade100,
                                  Colors.deepPurple.shade50,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Container cho text và icon
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.deepPurple.shade100,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple.shade50.withOpacity(0.5),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.history_rounded,
                              size: 16,
                              color: Colors.deepPurple.shade400,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Lastest Transactions',
                              style: TextStyle(
                                color: Colors.deepPurple.shade400,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.receipt_long,
                                  size: 70, color: Colors.deepPurple.shade200),
                              const SizedBox(height: 16),
                              Text(
                                "No transactions found",
                                style: TextStyle(
                                  color: Colors.deepPurple.shade300,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: sortedKeys.length,
                          padding: const EdgeInsets.only(bottom: 100),
                          itemBuilder: (context, index) {
                            final dateKey = sortedKeys[index];
                            final date = DateTime.parse(dateKey);
                            final txs = grouped[dateKey]!;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: Text(
                                    DateFormat('EEEE, MMMM d').format(date),
                                    style: TextStyle(
                                      color: Colors.deepPurple.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                ...txs
                                    .map((t) => _buildTransactionItem(t))
                                    .toList(),
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
              );
              _loadTransactions(); // Reload after adding new transaction
            },
            backgroundColor: Colors.deepPurple.shade400,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(String label, double amount, Color color) {
    return Container(
      width: double.infinity, // Để card rộng full màn hình
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        // Đổi thành Row để label và amount nằm cùng hàng
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            NumberFormat('#,###').format(amount),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Transaction t) {
    final isIncome = t.type == 'income';
    final icon = isIncome
        ? TransactionIcons.incomeIcons[t.category.toLowerCase()]
        : TransactionIcons.expenseIcons[t.category.toLowerCase()];

    return Slidable(
      key: ValueKey(t),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: 0.5, // rộng hơn cho nút thoáng
        children: [
          // Edit Button - Màu xanh hiện đại
          SlidableAction(
            onPressed: (_) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionDetailScreen(transaction: t),
                ),
              ).then((_) => setState(() {}));
            },
            backgroundColor: Colors.blue.shade50,
            foregroundColor: Colors.blue.shade700,
            icon: Icons.edit_rounded,
            label: 'Edit',
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            autoClose: true,
          ),

          // Delete Button - Màu đỏ nhẹ
          SlidableAction(
            onPressed: (_) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  title: Text('Delete Transaction',
                      style: TextStyle(color: Colors.red.shade700)),
                  content: const Text(
                      'Are you sure you want to delete this transaction?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Provider.of<TransactionProvider>(context, listen: false)
                            .deleteTransaction(t);
                        Navigator.pop(context);
                      },
                      child: Text('Delete',
                          style: TextStyle(color: Colors.red.shade700)),
                    ),
                  ],
                ),
              );
            },
            backgroundColor: Colors.red.shade50,
            foregroundColor: Colors.red.shade700,
            icon: Icons.delete_rounded,
            label: 'Delete',
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            autoClose: true,
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransactionDetailScreen(transaction: t),
            ),
          ).then((_) {
            // Refresh list after viewing/editing details
            setState(() {});
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isIncome ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon ?? Icons.category,
                color: isIncome ? Colors.green : Colors.red,
              ),
            ),
            title: Text(
              t.category,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              t.note ?? 'No note',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  (isIncome ? '+' : '-') +
                      NumberFormat('#,###').format(t.amount),
                  style: TextStyle(
                    color: isIncome ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  t.paymentMethod,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
