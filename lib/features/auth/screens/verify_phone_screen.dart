import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/api_client.dart';
import 'package:flutter_application_1/features/auth/enums/otp_purpose.enum.dart';
import 'package:flutter_application_1/features/auth/models/request_otp_dto.dart';
import 'package:flutter_application_1/features/auth/models/user.dart';
import 'package:flutter_application_1/features/auth/models/verify_otp_dto.dart';
import 'package:flutter_application_1/features/auth/services/auth_service.dart';

class VerifyPhoneScreen extends StatefulWidget {
  final User user;
  final AuthService authService; // phone number passed from registration

  const VerifyPhoneScreen({
    super.key,
    required this.user,
    required this.authService,
  });

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isResendEnabled = true;
  int _resendSeconds = 30;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _startResendCooldown() {
    if (!mounted) return;
    setState(() {
      _isResendEnabled = false;
      _resendSeconds = 30;
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_resendSeconds == 0) {
        timer.cancel();
        setState(() => _isResendEnabled = true);
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a 6-digit OTP'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final VerifyOtpDto payload = VerifyOtpDto(
        purpose: OtpPurpose.phoneVerification.value,
        userId: widget.user.id,
        otp: _otpController.text,
      );

      await widget.authService.verifyOtp(payload);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phone verified successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to Login (or Home if you want auto-login)
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
      return; // back to login
    } on DioException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(ApiClient.extractErrorMessage(e))));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _resendOtp() async {
    final RequestOtpDto payload = RequestOtpDto(
      purpose: OtpPurpose.phoneVerification.value,
      userId: widget.user.id,
    );

    await widget.authService.requestOtp(payload);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP Sent!'), backgroundColor: Colors.green),
    );
    _startResendCooldown();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Phone')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter the OTP sent to ${user.phone}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _verifyOtp,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Verify'),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _isResendEnabled ? _resendOtp : null,
              child: _isResendEnabled
                  ? const Text('Resend OTP')
                  : Text('Resend in $_resendSeconds s'),
            ),
          ],
        ),
      ),
    );
  }
}
