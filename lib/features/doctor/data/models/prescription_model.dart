import 'package:dermai/features/core/entities/prescription.dart';

class PrescriptionModel extends Prescription {
  PrescriptionModel({
    required super.medcine,
    required super.dosage,
    required super.frequency,
    required super.datePrescribed,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      medcine: json['medcine'],
      dosage: json['dosage'],
      frequency: json['frequency'],
      datePrescribed: DateTime.parse(json['datePrescribed']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medcine': medcine,
      'dosage': dosage,
      'frequency': frequency,
      'datePrescribed': datePrescribed.toIso8601String(),
    };
  }
}


