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
  final String? diagnosedID;
  DoctorAppointments({required this.doctorID, this.patientID, this.diagnosedID});
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

final class DoctorConnectStreamEvent extends DoctorEvent {
  final String id;
  final String name;
  DoctorConnectStreamEvent({required this.id, required this.name});
}

final class DoctorCallPatientEvent extends DoctorEvent {
  final String patientID;
  final String appointmentID;
  DoctorCallPatientEvent({required this.patientID, required this.appointmentID});
}
