part of 'doctor_bloc.dart';

@immutable
sealed class DoctorState {
  const DoctorState();
}

final class DoctorInitial extends DoctorState {}

final class DoctorLoading extends DoctorState {}

final class DoctorSuccess extends DoctorState {}

final class DoctorFailure extends DoctorState {
  final String message;

  const DoctorFailure({required this.message});
}

final class DoctorSuccessCases extends DoctorState {
  final List<(DiagnosedDisease, Patient, Disease)> diagnosedDiseases;

  const DoctorSuccessCases({required this.diagnosedDiseases});

}

final class DoctorFailureCases extends DoctorState {
  final String message;

  const DoctorFailureCases({required this.message});
}

final class DoctorSuccessAppointments extends DoctorState {
  final List<(Appointment, DiagnosedDisease, Patient, Disease)> appointments;

  const DoctorSuccessAppointments({required this.appointments});
}

final class DoctorFailureAppointments extends DoctorState {
  final String message;

  const DoctorFailureAppointments({required this.message});
}

final class DoctorSuccessAvailableSlot extends DoctorState {
  final List<NeatCleanCalendarEvent> availableSlots;

  const DoctorSuccessAvailableSlot({required this.availableSlots});
}

final class DoctorFailureAvailableSlot extends DoctorState {
  final String message;

  const DoctorFailureAvailableSlot({required this.message});
}

final class DoctorSuccessCaseDetails extends DoctorState {
  final DiagnosedDisease diagnosedDisease;
  final Patient patient;
  final Disease disease;

  const DoctorSuccessCaseDetails({required this.diagnosedDisease, required this.patient, required this.disease});
}

final class DoctorFailureCaseDetails extends DoctorState {
  final String message;

  const DoctorFailureCaseDetails({required this.message});
}

final class DoctorSuccessAppointment extends DoctorState {
  final (Appointment, DiagnosedDisease, Patient, Disease) response;

  const DoctorSuccessAppointment({required this.response});
}

final class DoctorFailureAppointment extends DoctorState {
  final String message;

  const DoctorFailureAppointment({required this.message});
}

final class DoctorSuccessSignOut extends DoctorState {}

final class DoctorFailureSignOut extends DoctorState {
  final String message;

  const DoctorFailureSignOut({required this.message});
}

final class DoctorSuccessCallPatient extends DoctorState {
  final Call call;

  const DoctorSuccessCallPatient({required this.call});
}

final class DoctorFailureCallPatient extends DoctorState {
  final String message;

  const DoctorFailureCallPatient({required this.message});
}