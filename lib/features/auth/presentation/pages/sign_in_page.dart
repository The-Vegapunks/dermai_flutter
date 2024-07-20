import 'package:dermai/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:dermai/features/core/presentation/textfields.dart';
import 'package:dermai/features/patient/presentation/pages/root_page.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: const Text('Sign In'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            );
          },
        ),
      ),
      body:  Column(
        children: [
          const SizedBox(height: 64),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: EmailTextField(onChanged: (value) => {
              _email = value
            },),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ObscuredTextField(
                labelText: 'Password', 
                icon: const Icon(Icons.lock),
                onChanged: (value) => {
                  _password = value
                },),
          ),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () { 
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordPage()));
                 },
                child: const Text('Forgot Password'),
              ),
            ],
          )),
          const Expanded(child: SizedBox(height: 16)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_validateInputs()) {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const RootPage()));
                      }
                    },
                    child: const Text('Sign In'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  bool _validateInputs() {
  
  if (_email == null || _email!.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter your email.'),
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
