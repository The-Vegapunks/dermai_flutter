import 'package:flutter/material.dart';

class ReschedulePage extends StatefulWidget {
  const ReschedulePage({super.key});

  @override
  State<ReschedulePage> createState() => _ReschedulePageState();
}

class _ReschedulePageState extends State<ReschedulePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Reschedule Page'),
      ),
    );
  }
}