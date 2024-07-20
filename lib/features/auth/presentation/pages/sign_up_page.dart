import 'package:dermai/features/core/presentation/textfields.dart';
import 'package:dermai/features/patient/presentation/pages/root_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool? _isPrivacyPolicyChecked = false;

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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: UniversalTextField(labelText: "Full Name", icon: Icon(Icons.person),),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: EmailTextField()
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ObscuredTextField(labelText: 'Password', icon: Icon(Icons.lock_outline)),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ObscuredTextField(labelText: 'Confirm Password', icon: Icon(Icons.lock)),
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const RootPage()));
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
}