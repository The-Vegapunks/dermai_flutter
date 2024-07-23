import 'package:flutter/material.dart';

class FpResetPasswordPage extends StatefulWidget {
  final String email;
  const FpResetPasswordPage({super.key, required this.email});

  @override
  State<FpResetPasswordPage> createState() => _FpResetPasswordPageState();
}

class _FpResetPasswordPageState extends State<FpResetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    final String _email = widget.email;
    var _password = '';
    var _confirmPassword = '';
    var _token = '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Reset Password for $_email'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement reset password logic here
              },
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}