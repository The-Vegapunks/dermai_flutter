import 'package:dermai/features/core/entities/doctor.dart';

class DoctorModel extends Doctor {
  DoctorModel({
    required super.id,
    required super.name,
    required super.email,
    required super.address,
    required super.dateJoined,
  });

  factory DoctorModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return DoctorModel(id: '', name: '', email: '', address: '', dateJoined: DateTime.now());
    return DoctorModel(
      id: json['doctorID'],
      name: json['name'],
      email: json['email'],
      address: json['address'],
      dateJoined: DateTime.parse(json['dateJoined']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address,
      'dateJoined': dateJoined.toIso8601String(),
    };
  }
}
