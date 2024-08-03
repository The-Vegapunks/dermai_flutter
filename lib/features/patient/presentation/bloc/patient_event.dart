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
  final String? diagnosedID;
  PatientAppointments({required this.patientID, this.doctorID, this.diagnosedID});
}

final class PatientCancelAppointmentEvent extends PatientEvent {
  final String appointmentID;

  PatientCancelAppointmentEvent({required this.appointmentID});
}

final class PatientSubmitCaseEvent extends PatientEvent {
  final String imagePath;
  final String patientComment;
  PatientSubmitCaseEvent({required this.imagePath, required this.patientComment});
}

final class PatientListenMessages extends PatientEvent {
  final String diagnosedID;
  PatientListenMessages({required this.diagnosedID});
}

final class PatientSendMessageEvent extends PatientEvent {
  final String diagnosedID;
  final String diseaseName;
  final List<Message> previousMessages;
  PatientSendMessageEvent({required this.diagnosedID, required this.diseaseName, required this.previousMessages});
}