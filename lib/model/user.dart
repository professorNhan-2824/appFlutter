class User {
  final String id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  // Chuyển JSON thành object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'], // MongoDB trả về id dưới key "_id"
      name: json['name'],
      email: json['email'],
    );
  }

  // Nếu cần chuyển User thành JSON (ví dụ khi gửi dữ liệu lên server)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
