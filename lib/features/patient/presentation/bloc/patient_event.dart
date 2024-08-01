part of 'patient_bloc.dart';

@immutable
sealed class PatientEvent {}

final class PatientDiagnosedDiseases extends PatientEvent {
  final String patientID;
  PatientDiagnosedDiseases({required this.patientID});
}

final class PatientSignOut extends PatientEvent {}

final class PatientAppointments extends PatientEvent {
  final String patientID;
  final String? doctorID;
  PatientAppointments({required this.patientID, this.doctorID});
}