class User {
  final int? id;
  final String username;
  final String email;
  final String? password;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    required this.username,
    required this.email,
    this.password,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['users_id'],
      username: json['username'],
      email: json['email'],
      createdAt:
          json['create_at'] != null ? DateTime.parse(json['create_at']) : null,
      updatedAt:
          json['update_at'] != null ? DateTime.parse(json['update_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
    };
  }
}
