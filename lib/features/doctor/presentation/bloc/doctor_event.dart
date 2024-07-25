part of 'doctor_bloc.dart';

@immutable
sealed class DoctorEvent {}

final class DoctorDiagnosedDisease extends DoctorEvent {
  final String doctorID;
  final CasesType casesType;
  DoctorDiagnosedDisease({required this.doctorID, required this.casesType});
}
