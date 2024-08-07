import 'dart:ffi';

class Prescription {
  Prescription({
    required this.medcine,
    required this.dosage,
    required this.frequency,
    required this.datePrescribed,
  });

  final String medcine;
  final Float dosage;
  final int frequency;
  final DateTime datePrescribed;
}