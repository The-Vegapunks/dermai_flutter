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

  final String appointmentID;
  final DateTime dateCreated;
  final String status;
  final String comment;
  final String description;
  final String diagnosedID;
  final bool isPhysical;
}