import 'package:flutter/material.dart';

class AppConstants{
  // Loai tai khoan (account type)
  static const List<String> accountType =
  [
    "Tiền mặt",
    "Tài khoản ngân hàng",
    "Ví điện tử",
    "Tài khoản tiết kiệm",
    "Tài khoản đầu tư",
    "Tài khoản khác"
  ];

  // Loai giao dich (transaction type)
  static const List<String> transactionType =
  [
    "Thu nhập",
    "Chi tiêu",
    "Chuyển khoản",
  ];

  // Tan suat giao dich dinh ky (regular transaction frequency)
  static const List<String> regularTransactionFrequency =
  [
    "Hàng ngày",
    "Hàng tuần",
    "Hàng tháng",
    "Hàng quý",
    "Hàng năm",
  ];

  // Loai bao cao (report type)
  static const List<String> reportType =
  [
    "Báo cáo tài chính",
    "Báo cáo thu nhập",
    "Báo cáo chi tiêu",
    "Báo cáo tài sản",
    "Báo cáo nợ",
    "Báo cáo giao dịch",
  ];

  // Loai thong bao (notification type)
  static const List<String> notificationType =
  [
    "Cảnh báo",
    "Thông báo",
  ];

  // Loai file dinh kem (attachment file type)
  static const List<String> attachmentFileType =
  [
    "image/jpeg",
    "image/png",
    "application/pdf",
    "application/vnd.ms-excel"
  ];
  List<Map<String, dynamic>> categories = [
    {"name": "Shopping", "icon": Icons.shopping_cart, "type": "expense"},
    {"name": "Food", "icon": Icons.restaurant, "type": "expense"},
    {"name": "Phone", "icon": Icons.phone_iphone, "type": "expense"},
    {"name": "Entertainment", "icon": Icons.mic, "type": "expense"},
    {"name": "Education", "icon": Icons.book, "type": "expense"},
    {"name": "Beauty", "icon": Icons.face, "type": "expense"},
    {"name": "Sports", "icon": Icons.pool, "type": "expense"},
    {"name": "Social", "icon": Icons.people, "type": "expense"},
    {"name": "Transportation", "icon": Icons.directions_bus, "type": "expense"},
    {"name": "Clothing", "icon": Icons.checkroom, "type": "expense"},
    {"name": "Car", "icon": Icons.directions_car, "type": "expense"},
    {"name": "Alcohol", "icon": Icons.local_bar, "type": "expense"},
    {"name": "Cigarettes", "icon": Icons.smoking_rooms, "type": "expense"},
    {"name": "Electronics", "icon": Icons.headphones, "type": "expense"},
    {"name": "Travel", "icon": Icons.airplanemode_active, "type": "expense"},
    {"name": "Health", "icon": Icons.medical_services, "type": "expense"},
    {"name": "Pets", "icon": Icons.pets, "type": "expense"},
    {"name": "Repairs", "icon": Icons.build, "type": "expense"},
    {"name": "Housing", "icon": Icons.format_paint, "type": "expense"},
    {"name": "Home", "icon": Icons.kitchen, "type": "expense"},
    {"name": "Gifts", "icon": Icons.card_giftcard, "type": "expense"},
    {"name": "Donations", "icon": Icons.favorite, "type": "expense"},
    {"name": "Lottery", "icon": Icons.sports_esports, "type": "expense"},
    {"name": "Snacks", "icon": Icons.cake, "type": "expense"},
    {"name": "Kids", "icon": Icons.child_care, "type": "expense"},
    {"name": "Vegetables", "icon": Icons.eco, "type": "expense"},
    {"name": "Fruits", "icon": Icons.grain, "type": "expense"},
    {"name": "Settings", "icon": Icons.settings, "type": "expense"},
    {"name": "Salary", "icon": Icons.monetization_on, "type": "income"},
    {"name": "Gifts", "icon": Icons.card_giftcard, "type": "income"},
    {"name": "Investments", "icon": Icons.trending_up, "type": "income"},
    {"name": "Lottery", "icon": Icons.sports_esports, "type": "income"},
    {"name": "Refunds", "icon": Icons.money_off, "type": "income"},
    {"name": "Savings", "icon": Icons.account_balance, "type": "income"},
    {"name": "Sales", "icon": Icons.shopping_cart, "type": "income"},
    {"name": "Rent", "icon": Icons.home, "type": "income"},
    {"name": "Interests", "icon": Icons.account_balance_wallet, "type": "income"},
    {"name": "Others", "icon": Icons.more_horiz, "type": "income"}
  ];

  List<Map<String, dynamic>> getCategories(String type) {
    return categories.where((element) => element["type"] == type).toList();
  }
}