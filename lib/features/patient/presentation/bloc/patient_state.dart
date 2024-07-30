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
  final List<(DiagnosedDisease, Disease, Doctor)> diagnosedDiseases;

  const PatientSuccessDiagnosedDiseases({required this.diagnosedDiseases});

}
