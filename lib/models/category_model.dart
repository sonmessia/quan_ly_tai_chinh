class Category {
  final String id;
  final String name;
  final String type; // 'income' or 'expense'
  final String? icon;
  final int? userId; // if user can create custom categories

  Category({
    required this.id,
    required this.name,
    required this.type,
    this.icon,
    this.userId,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      icon: json['icon'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'icon': icon,
      'user_id': userId,
    };
  }
}
