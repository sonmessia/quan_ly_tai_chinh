class Transaction {
  final String type;
  final String category;
  final double amount;
  final String paymentMethod;
  final String status;
  final DateTime date;

  Transaction({
    required this.type,
    required this.category,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    required this.date,
  });
}
