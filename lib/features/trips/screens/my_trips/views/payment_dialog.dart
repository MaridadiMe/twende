import 'package:flutter/material.dart';

class PaymentDialog extends StatefulWidget {
  final String initialPhone;
  final Future<bool> Function(String phone) onConfirm;

  const PaymentDialog({
    super.key,
    required this.initialPhone,
    required this.onConfirm,
  });

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  late TextEditingController _phoneController;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.initialPhone);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Payment Mobile'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'You will receive a prompt on your phone to complete the payment.',
            // style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: '2557XXXXXXXX',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _handleConfirm,
          child: _loading
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Pay'),
        ),
      ],
    );
  }

  Future<void> _handleConfirm() async {
    final phone = _phoneController.text.trim();

    if (!_isValidPhone(phone)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter valid phone number')));
      return;
    }

    setState(() => _loading = true);

    final success = await widget.onConfirm(phone);

    setState(() => _loading = false);

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Payment failed')));
    }
  }

  bool _isValidPhone(String phone) {
    return RegExp(r'^255\d{9}$').hasMatch(phone);
  }
}
