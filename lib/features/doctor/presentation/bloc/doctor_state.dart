part of 'doctor_bloc.dart';

@immutable
sealed class DoctorState {
  const DoctorState();
}

final class DoctorInitial extends DoctorState {}

final class DoctorLoading extends DoctorState {}

final class DoctorSuccess extends DoctorState {}

final class DoctorSuccessCases extends DoctorState {
  final List<(DiagnosedDisease, Patient, Disease)> diagnosedDiseases;

  const DoctorSuccessCases({required this.diagnosedDiseases});

}

final class DoctorSuccessAppointments extends DoctorState {
  final List<(Appointment, DiagnosedDisease, Patient, Disease)> appointments;

  const DoctorSuccessAppointments({required this.appointments});
}

final class DoctorSuccessAvailableSlot extends DoctorState {
  final List<NeatCleanCalendarEvent> availableSlots;

  const DoctorSuccessAvailableSlot({required this.availableSlots});
}

final class DoctorSuccessCaseDetails extends DoctorState {
  final DiagnosedDisease diagnosedDisease;
  final Patient patient;
  final Disease disease;

  const DoctorSuccessCaseDetails({required this.diagnosedDisease, required this.patient, required this.disease});
}

final class DoctorFailure extends DoctorState {
  final String message;

  const DoctorFailure({required this.message});
}

final class DoctorSuccessAppointment extends DoctorState {
  final (Appointment, DiagnosedDisease, Patient, Disease) response;

  const DoctorSuccessAppointment({required this.response});
}

final class DoctorSuccessSignOut extends DoctorState {}

final class DoctorSuccessCallPatient extends DoctorState {
  final Call call;

  const DoctorSuccessCallPatient({required this.call});
}