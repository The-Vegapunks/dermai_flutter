import 'package:dermai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dermai/features/auth/presentation/pages/reset_password_page.dart';
import 'package:dermai/features/core/cubits/app_user/app_user_cubit.dart';
import 'package:dermai/features/core/entities/user.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import this for setting orientation

class OTPVerificationPage extends StatefulWidget {
  final String email;

  const OTPVerificationPage({super.key, required this.email});

  @override
  OTPVerificationPageState createState() => OTPVerificationPageState();
}

class OTPVerificationPageState extends State<OTPVerificationPage> {
  late Timer _timer;
  int _start = 60;
  var token = ["", "", "", "", "", ""];
  late final User? user;

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
    final authState = context.read<AppUserCubit>().state;
    if (authState is AppUserAuthenticated) {
      user = authState.user;
    } else {
      user = null;
    }
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccessOTPVerification) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordPage(
                email: widget.email,
              ),
            ),
          ).then(
            (value) {
              if (user != null) {
                Navigator.pop(context);
              }
            },
          );
        }
        if (state is AuthFailureOTPVerification) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }

        if (state is AuthSuccessResendOTP) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP has been resent to your email'),
            ),
          );
        }
        if (state is AuthFailureResendOTP) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ];
            },
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(child: SizedBox(height: 16)),
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
                    children:
                        List.generate(6, (index) => _buildOTPField(index)),
                  ),
                  const SizedBox(height: 20),
                  _start > 0
                      ? Text('Resend OTP in $_start seconds')
                      : TextButton(
                          onPressed: () {
                            resetTimer();
                            context.read<AuthBloc>().add(
                                  AuthSendOTPEvent(
                                    resend: true,
                                    email: widget.email,
                                  ),
                                );
                          },
                          child: const Text('Resend OTP'),
                        ),
                  const Expanded(child: SizedBox(height: 16)),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(
                                  AuthOTPVerificationEvent(
                                    email: widget.email,
                                    token: token.join(""),
                                  ),
                                );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (state is! AuthLoading)
                                const Text('Verify OTP')
                              else
                                const Text('Verifying OTP'),
                              if (state is AuthLoading)
                                const SizedBox(width: 8),
                              if (state is AuthLoading)
                                const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
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
