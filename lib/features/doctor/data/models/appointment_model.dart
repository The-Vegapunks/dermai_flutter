import 'package:dermai/features/core/entities/appointment.dart';

class AppointmentModel extends Appointment {
  AppointmentModel({
    required super.appointmentID,
    required super.dateCreated,
    required super.status,
    required super.comment,
    required super.description,
    required super.diagnosedID,
    required super.isPhysical,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      appointmentID: json['appointmentID'],
      dateCreated: DateTime.parse(json['dateCreated']),
      status: json['status'],
      comment: json['comment'],
      description: json['description'],
      diagnosedID: json['diagnosedID'],
      isPhysical: json['isPhysical'],
    );
  }
}