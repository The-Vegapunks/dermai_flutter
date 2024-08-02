part of 'patient_bloc.dart';

@immutable
sealed class PatientState {
  const PatientState();
}

final class PatientInitial extends PatientState {}

final class PatientLoading extends PatientState {}

final class PatientSuccess extends PatientState {}

final class PatientFailure extends PatientState {
  final String message;

  const PatientFailure({required this.message});

}

final class PatientSuccessDiagnosedDiseases extends PatientState {
  final List<(DiagnosedDisease, Disease, Doctor?)> diagnosedDiseases;

  const PatientSuccessDiagnosedDiseases({required this.diagnosedDiseases});

}

final class PatientSuccessAppointments extends PatientState {
  final Map<DateTime, List<(Appointment, DiagnosedDisease, Doctor, Disease)>> appointments;

  const PatientSuccessAppointments({required this.appointments});

}

final class PatientSuccessCancelAppointment extends PatientState {}

final class PatientSuccessSubmitCase extends PatientState {
  final DiagnosedDisease diagnosedDisease;
  final Disease disease;

  const PatientSuccessSubmitCase({required this.diagnosedDisease, required this.disease});
}

final class PatientSuccessSignOut extends PatientState {}
