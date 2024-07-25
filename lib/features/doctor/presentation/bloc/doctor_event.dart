part of 'doctor_bloc.dart';

@immutable
sealed class DoctorEvent {}

final class DoctorDiagnosedDisease extends DoctorEvent {
  final String doctorID;
  final CasesType casesType;
  DoctorDiagnosedDisease({required this.doctorID, required this.casesType});
}

final class DoctorCaseDetails extends DoctorEvent {
  final String diagnosedID;
  DoctorCaseDetails({required this.diagnosedID});
}

final class DoctorUpdateCase extends DoctorEvent {
  final DiagnosedDisease diagnosedDisease;
  DoctorUpdateCase({required this.diagnosedDisease});
}
