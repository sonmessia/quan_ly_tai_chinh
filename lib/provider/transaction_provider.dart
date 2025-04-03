import 'package:flutter/foundation.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  List<Transaction> get transactions => _transactions;

  Future<void> loadTransactions(int userId) async {
    try {
      _transactions = await TransactionService.getTransactionsByUserId(userId);
      print(
          'Loaded ${_transactions.length} transactions in provider'); // Debug print
      notifyListeners();
    } catch (e) {
      print('Error loading transactions in provider: $e');
    }
  }

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
  void updateTransaction(
      Transaction oldTransaction, Transaction newTransaction) {
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

  void setTransactions(List<Transaction> transactions) {
    _transactions = transactions;
    notifyListeners();
  }
}
