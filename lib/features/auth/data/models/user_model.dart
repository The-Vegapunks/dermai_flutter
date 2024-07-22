import 'package:dermai/features/core/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.isDoctor,
    required super.specialization,
    required super.dateJoined,
  });
  factory UserModel.fromJsonDoctor(Map<String, dynamic> json) {
    return UserModel(
      id: json['doctorID'],
      name: json['name'],
      email: json['email'],
      isDoctor: true,
      specialization: json['specialization'],
      dateJoined: DateTime.parse(json['dateJoined']),
    );
  }
  factory UserModel.fromJsonPatient(Map<String, dynamic> json) {
    return UserModel(
      id: json['patientID'],
      name: json['name'],
      email: json['email'],
      isDoctor: false,
      specialization: '',
      dateJoined: DateTime.now(),
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    bool? isDoctor,
    String? specialization,
    DateTime? dateJoined,
  }) {
    return UserModel(
      id: id ?? super.id,
      name: name ?? super.name,
      email: email ?? super.email,
      isDoctor: isDoctor ?? super.isDoctor,
      specialization: specialization ?? super.specialization,
      dateJoined: dateJoined ?? super.dateJoined,
    );
  }
}