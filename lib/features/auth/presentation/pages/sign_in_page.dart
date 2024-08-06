import 'package:dermai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dermai/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:dermai/features/core/presentation/textfields.dart';
import 'package:dermai/features/patient/presentation/pages/root_page.dart'
    as patient;
import 'package:dermai/features/doctor/presentation/pages/root_page.dart'
    as doctor;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
          if (state is AuthSuccess) {
            if (state.user.isDoctor) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const doctor.RootPage(),
                  ),
                  (Route<dynamic> route) => false);
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const patient.RootPage(),
                  ),
                  (Route<dynamic> route) => false);
            }
          }
        },
        builder: (context, state) {
          return AbsorbPointer(
            absorbing: state is AuthLoading,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar.large(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    tooltip:
                        MaterialLocalizations.of(context).backButtonTooltip,
                  ),
                  title: const Text('Sign In'),
                ),
                SliverToBoxAdapter(
                  child: Column(children: [
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: EmailTextField(
                        onChanged: (value) => {_email = value},
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ObscuredTextField(
                        labelText: 'Password',
                        icon: const Icon(Icons.lock),
                        onChanged: (value) => {_password = value},
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPasswordPage()));
                              },
                              child: const Text('Forgot Password'),
                            ),
                          ],
                        )),
                  ]),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      const Expanded(child: SizedBox(height: 16)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_validateInputs()) {
                                    context.read<AuthBloc>().add(
                                          AuthSignInEvent(
                                            email: _email!.trim(),
                                            password: _password!.trim(),
                                          ),
                                        );
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (state is! AuthLoading)
                                      const Text('Sign In')
                                    else
                                      const Text('Signing In'),
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
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _validateInputs() {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

    if (_email == null || _email!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email.'),
        ),
      );
      return false;
    }
    if (!emailRegex.hasMatch(_email!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address.'),
        ),
      );
      return false;
    }
    if (_password == null || _password!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your password.'),
        ),
      );
      return false;
    }
    return true;
  }
}
