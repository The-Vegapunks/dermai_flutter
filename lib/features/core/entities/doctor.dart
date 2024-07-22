class Doctor {
  Doctor({
    required this.id,
    required this.name,
    required this.email,
    required this.specialization,
    required this.dateJoined,
  });

  final String id;
  final String name;
  final String email;
  final String specialization;
  final DateTime dateJoined;
}