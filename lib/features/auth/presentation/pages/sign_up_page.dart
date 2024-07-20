import 'package:dermai/features/core/presentation/textfields.dart';
import 'package:dermai/features/patient/presentation/pages/root_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool? _isPrivacyPolicyChecked = false;
  String? _fullName;
  String? _email;
  String? _password;
  String? _confirmPassword;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
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
      body: Column(
        children: [
          const SizedBox(height: 64),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: UniversalTextField(labelText: "Full Name", icon: const Icon(Icons.person), onChanged: (value) => {
              setState(() {
                _fullName = value;
              })
            },),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: EmailTextField(onChanged: (value) => {
              _email = value
            },)
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ObscuredTextField(labelText: 'Password', icon: const Icon(Icons.lock_outline), onChanged: (value) => {
              _password = value
            },),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ObscuredTextField(labelText: 'Confirm Password', icon: const Icon(Icons.lock), onChanged: (value) => {
              _confirmPassword = value
            },),
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(value: _isPrivacyPolicyChecked, onChanged: (value) { 
                  setState(() {
                    _isPrivacyPolicyChecked = value;
                  });
                 }),
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: <TextSpan>[
                        const TextSpan(text: 'By joining, you agree to our '),
                        TextSpan(
                            text: 'Terms of Service',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: Theme.of(context).colorScheme.primary),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // todo
                              }),
                        const TextSpan(text: ' and '),
                        TextSpan(
                            text: 'Privacy Policy',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: Theme.of(context).colorScheme.primary),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // todo
                              }),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Expanded(child: SizedBox(height: 16)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: 
                      () {
                        if (_isPrivacyPolicyChecked == true){
                          if (_validateInputs()) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const RootPage()));
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please agree to the Terms of Service and Privacy Policy.'),
                            ),
                          );
                        }
                      },
                    child: const Text('Sign Up'),
                  ),
                ),
              ],
            ),
          ), 
          const SizedBox(height: 32),
      ]),
    );
  }

  bool _validateInputs() {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  if (_fullName == null || _fullName!.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter your full name.'),
      ),
    );
    return false;
  }

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
  if (_confirmPassword == null || _confirmPassword!.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please confirm your password.'),
      ),
    );
    return false;
  }
  if (_password != _confirmPassword) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Passwords do not match.'),
      ),
    );
    return false;
  }
  return true;
}
}

