import 'package:flutter/material.dart';

class CurrentCasesPage extends StatefulWidget {
  const CurrentCasesPage({super.key});

  @override
  State<CurrentCasesPage> createState() => _CurrentCasesPageState();
}

class _CurrentCasesPageState extends State<CurrentCasesPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Current Cases Page'),
      ),
    );
  }
}