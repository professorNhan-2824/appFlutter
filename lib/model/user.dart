class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  // Chuyển JSON thành object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
    );
  }
}
