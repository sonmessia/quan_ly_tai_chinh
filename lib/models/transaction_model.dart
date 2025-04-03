class Transaction {
  final String type;
  final int? userId;
  final String? id; // Change to String? since MongoDB uses string IDs
  final String categoryName;
  final double amount;
  final String paymentMethod;
  final String status;
  final DateTime date;
  final String? note;

  Transaction({
    required this.type,
    this.userId,
    this.id,
    required this.categoryName,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    required this.date,
    this.note,
  });

  // Add getter for backward compatibility
  String get category => categoryName;

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      type: json['type'] ?? '',
      userId: json['user_id'],
      id: json['transaction_id']?.toString(), // MongoDB uses _id
      categoryName: json['category_name'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      paymentMethod: json['payment_method'] ?? '', // Changed to match backend
      status: json['status'] ?? '',
      date:
          DateTime.parse(json['create_at'] ?? DateTime.now().toIso8601String()),
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'user_id': userId,
      'category_name': categoryName,
      'amount': amount,
      'payment_method': paymentMethod,
      'status': status,
      'date': date.toIso8601String(),
      'note': note,
    };
  }
}
