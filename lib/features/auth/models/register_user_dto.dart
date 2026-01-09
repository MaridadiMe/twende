class RegisterUserDto {
  final String phone;
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  RegisterUserDto({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }
}
