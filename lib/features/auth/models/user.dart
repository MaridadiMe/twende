class User {
  final String id;
  final String email;
  final String phone;
  final String firstName;
  final String lastName;
  final String userName;
  final List<String> permissions;

  User({
    required this.id,
    required this.email,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.permissions,
  });

  String get fullName => '$firstName $lastName';

  factory User.fromJwt(Map<String, dynamic> payload) {
    return User(
      id: payload['sub'],
      email: payload['email'],
      phone: payload['phone'],
      firstName: payload['firstName'],
      lastName: payload['lastName'],
      userName: payload['userName'],
      permissions: List<String>.from(payload['permissions'] ?? []),
    );
  }
}
