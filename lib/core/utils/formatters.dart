import "package:intl/intl.dart";

class Formatter {
  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(amount);
  }
}