class Appointment {
  const Appointment({
    required this.appointmentID,
    required this.dateCreated,
    required this.status,
    required this.comment,
    required this.description,
    required this.diagnosedID,
    required this.isPhysical,
  });

  final String? appointmentID;
  final DateTime dateCreated;
  final AppointmentStatus status;
  final String comment;
  final String description;
  final String diagnosedID;
  final bool isPhysical;

  Appointment copyWith({
    String? appointmentID,
    DateTime? dateCreated,
    AppointmentStatus? status,
    String? comment,
    String? description,
    String? diagnosedID,
    bool? isPhysical,
  }) {
    return Appointment(
      appointmentID: appointmentID ?? this.appointmentID,
      dateCreated: dateCreated ?? this.dateCreated,
      status: status ?? this.status,
      comment: comment ?? this.comment,
      description: description ?? this.description,
      diagnosedID: diagnosedID ?? this.diagnosedID,
      isPhysical: isPhysical ?? this.isPhysical,
    );
  }
}

enum AppointmentStatus {
  pending,
  followup,
  completed,
}




