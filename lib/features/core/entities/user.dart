import 'package:dermai/features/core/entities/doctor.dart';
import 'package:dermai/features/core/entities/patient.dart';

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.isDoctor,
    required this.address,
    required this.dateJoined,
  });

  final String id;
  final String name;
  final String email;
  final bool isDoctor;
  final String address;
  final DateTime dateJoined;

  patient() {
    return Patient(
      id: id,
      name: name,
      email: email,
    );
  }

  doctor() {
    return Doctor(
      id: id,
      name: name,
      email: email,
      address: address,
      dateJoined: dateJoined,
    );
  }
}