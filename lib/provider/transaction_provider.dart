import 'package:flutter/foundation.dart';
import '../models/transaction_model.dart';

class TransactionProvider with ChangeNotifier {
  final List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  // Hàm xóa transaction đơn giản không cần id
  void deleteTransaction(Transaction transaction) {
    _transactions.remove(transaction);
    notifyListeners();
  }

  // Hàm cập nhật transaction không cần id
  void updateTransaction(Transaction oldTransaction, Transaction newTransaction) {
    final index = _transactions.indexOf(oldTransaction);
    if (index != -1) {
      _transactions[index] = newTransaction;
      notifyListeners();
    }
  }

  // Getter để lấy tổng số transaction
  int get transactionCount => _transactions.length;

  // Getter để kiểm tra list có rỗng không
  bool get isEmpty => _transactions.isEmpty;
}