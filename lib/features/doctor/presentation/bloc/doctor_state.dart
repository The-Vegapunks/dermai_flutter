part of 'doctor_bloc.dart';

@immutable
sealed class DoctorState {
  const DoctorState();
}

final class DoctorInitial extends DoctorState {}

final class DoctorLoading extends DoctorState {}

final class DoctorSuccess extends DoctorState {}

final class DoctorSuccessListOfDiagnosedDisease extends DoctorState {
  final List<DiagnosedDisease> diagnosedDiseases;

  const DoctorSuccessListOfDiagnosedDisease({required this.diagnosedDiseases});

}

final class DoctorSuccessCaseDetails extends DoctorState {
  final DiagnosedDisease diagnosedDisease;

  const DoctorSuccessCaseDetails({required this.diagnosedDisease});
}

final class DoctorFailure extends DoctorState {
  final String message;

  const DoctorFailure({required this.message});
}
