import 'package:dermai/features/core/presentation/textfields.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
      body: const Column(
        children: [
          SizedBox(height: 64),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: UniversalTextField(labelText: "Full Name", icon: Icon(Icons.person),),
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: EmailTextField()
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ObscuredTextField(labelText: 'Password', icon: Icon(Icons.lock_outline)),
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ObscuredTextField(labelText: 'Confirm Password', icon: Icon(Icons.lock)),
          ),
          Expanded(child: SizedBox(height: 16)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: null,
                    child: Text('Sign Up'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
        
      ]),
    );
  }
}