import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CaseDetailPage extends StatefulWidget {
  const CaseDetailPage({super.key, required this.diagnosedID});

  final String diagnosedID;

  @override
  State<CaseDetailPage> createState() => _CaseDetailPageState();
}

class _CaseDetailPageState extends State<CaseDetailPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Case Detail Page'),
      ),
    );
  }
}