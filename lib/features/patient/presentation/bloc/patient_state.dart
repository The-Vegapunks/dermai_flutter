part of 'patient_bloc.dart';

@immutable
sealed class PatientState {
  const PatientState();
}

final class PatientInitial extends PatientState {}

final class PatientLoading extends PatientState {}

final class PatientSending extends PatientState {}

final class PatientTyping extends PatientState {}

final class PatientSuccess extends PatientState {}
final class PatientSuccessDiagnosedDiseases extends PatientState {
  final List<(DiagnosedDisease, Disease, Doctor?)> diagnosedDiseases;

  const PatientSuccessDiagnosedDiseases({required this.diagnosedDiseases});
}

final class PatientFailureDiagnosedDiseases extends PatientState {
  final String message;

  const PatientFailureDiagnosedDiseases({required this.message});
}

final class PatientSuccessAppointments extends PatientState {
  final Map<DateTime, List<(Appointment, DiagnosedDisease, Doctor, Disease)>>
      appointments;

  const PatientSuccessAppointments({required this.appointments});
}

final class PatientFailureAppointments extends PatientState {
  final String message;

  const PatientFailureAppointments({required this.message});
}

final class PatientSuccessCancelAppointment extends PatientState {}

final class PatientFailureCancelAppointment extends PatientState {
  final String message;

  const PatientFailureCancelAppointment({required this.message});
}

final class PatientSuccessSubmitCase extends PatientState {
  final DiagnosedDisease diagnosedDisease;
  final Disease disease;

  const PatientSuccessSubmitCase(
      {required this.diagnosedDisease, required this.disease});
}

final class PatientFailureSubmitCase extends PatientState {
  final String message;

  const PatientFailureSubmitCase({required this.message});
}

final class PatientSuccessSignOut extends PatientState {}

final class PatientFailureSignOut extends PatientState {
  final String message;

  const PatientFailureSignOut({required this.message});
}

final class PatientSuccessGetMessages extends PatientState {
  final List<Message> messages;

  const PatientSuccessGetMessages({required this.messages});
}

final class PatientFailureGetMessages extends PatientState {
  final String message;

  const PatientFailureGetMessages({required this.message});
}

final class PatientSuccessCallDoctor extends PatientState {
  final Call call;

  const PatientSuccessCallDoctor({required this.call});
}

final class PatientFailureCallDoctor extends PatientState {
  final String message;

  const PatientFailureCallDoctor({required this.message});
}

final class PatientSuccessDeleteDiagnosedDisease extends PatientState {}

final class PatientFailureDeleteDiagnosedDisease extends PatientState {
  final String message;

  const PatientFailureDeleteDiagnosedDisease({required this.message});
}

final class PatientFailureSendMessage extends PatientState {
  final String message;

  const PatientFailureSendMessage({required this.message});
}