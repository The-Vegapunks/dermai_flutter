import 'package:dermai/features/auth/presentation/pages/fp_reset_password_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart'; // Import this for setting orientation

class OTPVerificationScreen extends StatefulWidget {
  final String email;

  const OTPVerificationScreen({super.key, required this.email});

  @override
  OTPVerificationScreenState createState() => OTPVerificationScreenState();
}

class OTPVerificationScreenState extends State<OTPVerificationScreen> {
  late Timer _timer;
  int _start = 240; // 4 minutes timer

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_start > 0) {
          _start--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  void resetTimer() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    setState(() {
      _start = 240; // Reset the timer to 4 minutes
    });
    startTimer();
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    // Lock orientation to portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    _timer.cancel();
    // Reset orientation to default
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  void _verifyOTP() {
    // Replace this with your actual OTP verification logic
    bool isOTPCorrect = true; // Example condition

    if (isOTPCorrect) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FpResetPasswordPage(),
        ),
      );
    } 
    // else {
    //   // Handle incorrect OTP scenario
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Incorrect OTP')),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back when the back button is pressed
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'OTP Verification',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'One Time Password (OTP) has been sent via email to ${widget.email}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) => _buildOTPField(index)),
            ),
            const SizedBox(height: 20),
            _start > 0
                ? Text('Resend OTP in $_start seconds')
                : TextButton(
                    onPressed: () {
                      resetTimer();
                      // Handle resend OTP
                    },
                    child: const Text('Resend OTP'),
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyOTP,
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOTPField(int index) {
    return SizedBox(
      width: 40,
      child: TextField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: const InputDecoration(
          counterText: '',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            if (index != 5) {
              FocusScope.of(context).nextFocus();
            }
          }
        },
      ),
    );
  }
}
