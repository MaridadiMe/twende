class User {
  final String id;
  final String email;
  final String phone;
  final String firstName;
  final String lastName;
  final String userName;
  final String role;
  final List<String> permissions;

  User({
    required this.id,
    required this.email,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.permissions,
    required this.role,
  });

  String get fullName => '$firstName $lastName';

  bool hasPermission(String permission) {
    return permissions.contains(permission);
  }

  factory User.fromJwt(Map<String, dynamic> payload) {
    return User(
      id: payload['sub'],
      email: payload['email'],
      phone: payload['phone'],
      firstName: payload['firstName'],
      lastName: payload['lastName'],
      userName: payload['userName'],
      permissions: List<String>.from(payload['permissions'] ?? []),
      role: payload['role'],
    );
  }

  /// 🔹 Used for API responses (register, get profile, etc.)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      phone: json['phone'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
      role: json['role'] ?? 'user',
      permissions: const [], // ❗ Not provided during registration
    );
  }
}
