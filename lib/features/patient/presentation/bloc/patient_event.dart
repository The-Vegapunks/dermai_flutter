part of 'patient_bloc.dart';

@immutable
sealed class PatientEvent {}

final class PatientDiagnosedDiseases extends PatientEvent {
  final String patientID;
  PatientDiagnosedDiseases({required this.patientID});
}
