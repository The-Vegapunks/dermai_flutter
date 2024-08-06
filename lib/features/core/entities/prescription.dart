class Prescription {
  Prescription({
    required this.medcine,
    required this.dosage,
    required this.frequency,
    required this.datePrescribed,
  });

  final String medcine;
  final String dosage;
  final String frequency;
  final DateTime datePrescribed;
}