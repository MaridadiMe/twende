class RequestOtpDto {
  final String purpose;
  final String userId;

  RequestOtpDto({required this.purpose, required this.userId});

  Map<String, dynamic> toJson() {
    return {'purpose': purpose, 'userId': userId};
  }
}
