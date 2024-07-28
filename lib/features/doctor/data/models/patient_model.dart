import 'package:dermai/features/core/entities/patient.dart';

class PatientModel extends Patient {
  PatientModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['patientID'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}