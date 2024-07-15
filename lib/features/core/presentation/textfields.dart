
import 'package:flutter/material.dart';

class UniversalTextField extends StatelessWidget {
  const UniversalTextField({super.key, required this.labelText, this.icon});

  final String labelText;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      child: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
          prefixIcon: icon,
        ),
      ),
    );
  }
}

class ObscuredTextField extends StatelessWidget {
  const ObscuredTextField({super.key, required this.labelText, required this.icon});

  final String labelText;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
          prefixIcon: icon,
        ),
      ),
    );
  }
}

class EmailTextField extends StatelessWidget {
  const EmailTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Email',
          prefixIcon: Icon(Icons.email),
        ),
      ),
    );
  }
}