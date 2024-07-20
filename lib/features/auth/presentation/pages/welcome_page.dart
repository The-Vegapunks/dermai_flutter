import 'package:dermai/features/auth/presentation/pages/sign_in_page.dart';
import 'package:dermai/features/auth/presentation/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(child: SizedBox(height: 128)),
          Text('DermAI', style: Theme.of(context).textTheme.displayLarge),
          Text('By Vegapunks', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 16),
          const Expanded(child: SizedBox(height: 16)),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInPage()));
              },
              child: const Text('Sign In'),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage()));
              },
              child: const Text('Sign Up'),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    ));
  }
}
