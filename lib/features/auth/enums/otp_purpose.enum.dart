enum OtpPurpose {
  login('login'),
  phoneVerification('phone_verification'),
  passwordReset('password_reset');

  final String value;
  const OtpPurpose(this.value);
}
