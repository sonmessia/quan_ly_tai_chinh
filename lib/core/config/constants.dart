import 'package:flutter/material.dart';

/// Class chứa các icon cho giao dịch tài chính
class TransactionIcons {
  // EXPENSE ICONS (ICON CHI TIÊU)
  static const Map<String, IconData> expenseIcons = {
    // Mua sắm & Bán lẻ
    'shopping': Icons.shopping_bag,
    'groceries': Icons.shopping_cart,
    'clothes': Icons.checkroom,

    // Ăn uống
    'restaurant': Icons.restaurant,
    'coffee': Icons.coffee,
    'fastFood': Icons.fastfood,

    // Di chuyển
    'transportation': Icons.directions_car,
    'fuel': Icons.local_gas_station,
    'parking': Icons.local_parking,
    'taxi': Icons.local_taxi,
    'bus': Icons.directions_bus,

    // Nhà cửa & Tiện ích
    'home': Icons.home,
    'rent': Icons.apartment,
    'utilities': Icons.power,
    'internet': Icons.wifi,
    'phone': Icons.phone_android,

    // Sức khỏe
    'medical': Icons.local_hospital,
    'pharmacy': Icons.medical_services,

    // Giải trí
    'entertainment': Icons.movie,
    'movies': Icons.theaters,
    'games': Icons.sports_esports,

    // Giáo dục
    'education': Icons.school,
    'books': Icons.book,

    // Chi tiêu khác
    'gift': Icons.card_giftcard,
    'sports': Icons.sports_soccer,
    'travel': Icons.flight,
    'insurance': Icons.security,
  };

  // INCOME ICONS (ICON THU NHẬP)
  static const Map<String, IconData> incomeIcons = {
    // Việc làm
    'salary': Icons.account_balance_wallet,
    'bonus': Icons.stars,
    'overtime': Icons.access_time,

    // Kinh doanh
    'business': Icons.business_center,
    'profit': Icons.trending_up,

    // Đầu tư
    'investment': Icons.insert_chart,
    'dividends': Icons.monetization_on,
    'stocks': Icons.show_chart,

    // Thu nhập thụ động
    'rental': Icons.house,
    'interest': Icons.account_balance,

    // Thu nhập khác
    'freelance': Icons.computer,
    'gifts': Icons.redeem,
    'refunds': Icons.replay,
    'lottery': Icons.casino,
  };

  // PAYMENT METHOD ICONS (ICON PHƯƠNG THỨC THANH TOÁN)
  static const Map<String, IconData> paymentMethodIcons = {
    'cash': Icons.money,
    'creditCard': Icons.credit_card,
    'bankTransfer': Icons.account_balance,
    'eWallet': Icons.account_balance_wallet,
    'check': Icons.notes,
    'crypto': Icons.currency_bitcoin,
  };

  // STATUS ICONS (ICON TRẠNG THÁI)
  static const Map<String, IconData> statusIcons = {
    'completed': Icons.check_circle,
    'pending': Icons.pending,
    'failed': Icons.error,
    'recurring': Icons.repeat,
    'scheduled': Icons.schedule,
  };
}