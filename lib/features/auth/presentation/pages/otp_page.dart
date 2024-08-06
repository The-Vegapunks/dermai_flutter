import 'package:dermai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dermai/features/auth/presentation/pages/fp_reset_password_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import this for setting orientation

class OTPVerificationScreen extends StatefulWidget {
  final String email;

  const OTPVerificationScreen({super.key, required this.email});

  @override
  OTPVerificationScreenState createState() => OTPVerificationScreenState();
}

class OTPVerificationScreenState extends State<OTPVerificationScreen> {
  late Timer _timer;
  int _start = 10; // 4 minutes timer
  var token = ["", "", "", "", "", ""];

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
      _start = 10; // Reset the timer to 4 minutes
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccessRecovery) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FpResetPasswordPage(email: widget.email,),
            ),
          );
        }
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'An email has been resent with the token required to reset the password'),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('OTP Verification'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(
                    context); // Navigate back when the back button is pressed
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
                          context
                              .read<AuthBloc>()
                              .add(AuthForgetPassword(email: widget.email));
                        },
                        child: const Text('Resend OTP'),
                      ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthRecoverPasswordEvent(
                        email: widget.email, token: token.join("")));
                  },
                  child: const Text('Verify OTP'),
                ),
              ],
            ),
          ),
        );
      },
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
          token[index] = value;
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
