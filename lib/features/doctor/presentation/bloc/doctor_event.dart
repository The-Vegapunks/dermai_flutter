part of 'doctor_bloc.dart';

@immutable
sealed class DoctorEvent {}

final class DoctorCases extends DoctorEvent {
  final String doctorID;
  final CasesType casesType;
  DoctorCases({required this.doctorID, required this.casesType});
}

final class DoctorCaseDetails extends DoctorEvent {
  final String diagnosedID;
  DoctorCaseDetails({required this.diagnosedID});
}

final class DoctorUpdateCase extends DoctorEvent {
  final DiagnosedDisease diagnosedDisease;
  DoctorUpdateCase({required this.diagnosedDisease});
}

final class DoctorAppointments extends DoctorEvent {
  final String doctorID;
  final String? patientID;
  DoctorAppointments({required this.doctorID, this.patientID});
}

final class DoctorCancelAppointment extends DoctorEvent {
  final String appointmentID;
  DoctorCancelAppointment({required this.appointmentID});
}

final class DoctorAvailableSlot extends DoctorEvent {
  final String doctorID;
  final String? patientID;
  DoctorAvailableSlot({required this.doctorID, this.patientID});
}

final class DoctorUpdateAppointment extends DoctorEvent {
  final Appointment appointment;
  final bool insert;
  DoctorUpdateAppointment({required this.appointment, required this.insert});
}

final class DoctorSignOut extends DoctorEvent {}
