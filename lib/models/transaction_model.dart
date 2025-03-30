class Transaction {
  final String type;
  final String category;
  final double amount;
  final String paymentMethod;
  final String status;
  final DateTime date;
  final String? note;

  Transaction({
    required this.type,
    required this.category,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    required this.date,
    this.note
  }) {
    if (amount < 0) {
      throw ArgumentError.value(amount, 'amount', 'Amount must be greater than zero');
    }
    if (type.toLowerCase() != 'income' && type.toLowerCase() != 'expense') {
      throw ArgumentError.value(type, 'type', 'Type must be either "income" or "expense"');
    }
  }

  String get safeType => type.toLowerCase() == 'income' ? 'Income' : 'Expense';
  String get safeCategory => category.isEmpty ? 'Uncategorized' : category;
}
