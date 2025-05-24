import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneVerificationWidget extends StatefulWidget {
  final void Function(String phoneNumber) onVerified;

  const PhoneVerificationWidget({super.key, required this.onVerified});

  @override
  State<PhoneVerificationWidget> createState() => _PhoneVerificationWidgetState();
}

class _PhoneVerificationWidgetState extends State<PhoneVerificationWidget> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  String? _verificationId;
  bool _codeSent = false;
  bool _verifying = false;
  String? _error;

  Future<void> _sendCode() async {
    setState(() {
      _verifying = true;
      _error = null;
    });
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phoneController.text.trim(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval or instant verification
        await FirebaseAuth.instance.signInWithCredential(credential);
        widget.onVerified(_phoneController.text.trim());
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _error = e.message;
          _verifying = false;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _codeSent = true;
          _verifying = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  Future<void> _verifyCode() async {
    setState(() {
      _verifying = true;
      _error = null;
    });
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _codeController.text.trim(),
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      widget.onVerified(_phoneController.text.trim());
    } catch (e) {
      setState(() {
        _error = 'Invalid code';
        _verifying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!_codeSent)
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: 'Phone Number (+65...)'),
            keyboardType: TextInputType.phone,
          ),
        if (_codeSent)
          TextField(
            controller: _codeController,
            decoration: const InputDecoration(labelText: 'Enter OTP'),
            keyboardType: TextInputType.number,
          ),
        const SizedBox(height: 12),
        if (_error != null)
          Text(_error!, style: const TextStyle(color: Colors.red)),
        ElevatedButton(
          onPressed: _verifying
              ? null
              : !_codeSent
                  ? _sendCode
                  : _verifyCode,
          child: Text(_verifying
              ? 'Verifying...'
              : !_codeSent
                  ? 'Send Code'
                  : 'Verify Code'),
        ),
      ],
    );
  }
}