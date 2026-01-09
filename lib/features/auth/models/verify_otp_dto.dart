class VerifyOtpDto {
  final String purpose;
  final String userId;
  final String otp;

  VerifyOtpDto({
    required this.purpose,
    required this.userId,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {'otp': otp, 'purpose': purpose, 'userId': userId};
  }
}
