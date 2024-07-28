
import 'package:flutter/material.dart';

class UniversalTextField extends StatelessWidget {
  const UniversalTextField({super.key, required this.labelText, this.icon, required this.onChanged, this.initialValue, required this.maxLines});
  
  final String labelText;
  final Widget? icon;
  final String? initialValue;
  final Function(String) onChanged;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      child: TextFormField(
        maxLines: maxLines,
        initialValue: initialValue,
        onChanged: onChanged,
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
  const ObscuredTextField({super.key, required this.labelText, required this.icon, required this.onChanged});

  final String labelText;
  final Widget icon;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextField(
        onChanged: onChanged,
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
  const EmailTextField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextField(
        onChanged: onChanged,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Email',
          prefixIcon: Icon(Icons.email),
        ),
      ),
    );
  }
}