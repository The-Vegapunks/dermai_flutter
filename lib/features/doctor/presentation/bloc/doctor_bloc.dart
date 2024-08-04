import 'package:dermai/features/core/entities/appointment.dart';
import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/entities/patient.dart';
import 'package:dermai/features/doctor/domain/usecases/doctor_call_patient.dart';
import 'package:dermai/features/doctor/domain/usecases/doctor_cancel_appointment.dart'
    as usecasecancel;
import 'package:dermai/features/doctor/domain/usecases/doctor_connect_stream.dart';
import 'package:dermai/features/doctor/domain/usecases/doctor_get_appointments.dart';
import 'package:dermai/features/doctor/domain/usecases/doctor_get_available_appointment_slots.dart';
import 'package:dermai/features/doctor/domain/usecases/doctor_get_case_details.dart';
import 'package:dermai/features/doctor/domain/usecases/doctor_get_cases.dart';
import 'package:dermai/features/doctor/domain/usecases/doctor_sign_out_usecase.dart';
import 'package:dermai/features/doctor/domain/usecases/doctor_update_case_details.dart';
import 'package:dermai/features/doctor/domain/usecases/doctor_update_appointment.dart'
    as usecaseupdate;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

part 'doctor_event.dart';
part 'doctor_state.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  final DoctorGetCases _doctorGetDiagnosedDiseases;
  final DoctorGetCaseDetails _doctorGetCaseDetails;
  final DoctorUpdateCaseDetails _doctorUpdateCaseDetails;
  final DoctorGetAppointments _doctorGetAppointments;
  final usecasecancel.DoctorCancelAppointment _doctorCancelAppointment;
  final DoctorGetAvailableAppointmentSlots _doctorGetAvailableAppointmentSlots;
  final usecaseupdate.DoctorUpdateAppointment _doctorUpdateAppointment;
  final DoctorSignOutUsecase _doctorSignOut;
  final DoctorConnectStream _doctorConnectStream;
  final DoctorCallPatient _doctorCallPatient;
  DoctorBloc({
    required DoctorGetCases doctorGetDiagnosedDiseases,
    required DoctorGetCaseDetails doctorGetCaseDetails,
    required DoctorUpdateCaseDetails doctorUpdateCaseDetails,
    required DoctorGetAppointments doctorGetAppointments,
    required usecasecancel.DoctorCancelAppointment doctorCancelAppointment,
    required DoctorGetAvailableAppointmentSlots
        doctorGetAvailableAppointmentSlots,
    required usecaseupdate.DoctorUpdateAppointment doctorUpdateAppointment,
    required DoctorSignOutUsecase doctorSignOut,
    required DoctorConnectStream doctorConnectStream,
    required DoctorCallPatient doctorCallPatient,
  })  : _doctorGetDiagnosedDiseases = doctorGetDiagnosedDiseases,
        _doctorGetCaseDetails = doctorGetCaseDetails,
        _doctorUpdateCaseDetails = doctorUpdateCaseDetails,
        _doctorGetAppointments = doctorGetAppointments,
        _doctorCancelAppointment = doctorCancelAppointment,
        _doctorGetAvailableAppointmentSlots =
            doctorGetAvailableAppointmentSlots,
        _doctorUpdateAppointment = doctorUpdateAppointment,
        _doctorSignOut = doctorSignOut,
        _doctorConnectStream = doctorConnectStream,
        _doctorCallPatient = doctorCallPatient,
        super(DoctorInitial()) {
    on<DoctorCases>((event, emit) async {
      emit(DoctorLoading());

      final failureOrDiseases = await _doctorGetDiagnosedDiseases(
        DoctorGetCasesParams(
          doctorID: event.doctorID,
          casesType: event.casesType,
        ),
      );
      failureOrDiseases.fold(
        (failure) => emit(DoctorFailure(message: failure.message)),
        (response) => emit(DoctorSuccessCases(diagnosedDiseases: response)),
      );
    });
    on<DoctorCaseDetails>(
      (event, emit) async {
        final failureOrCaseDetails = await _doctorGetCaseDetails(
          DoctorGetCaseDetailsParams(
            diagnosedID: event.diagnosedID,
          ),
        );
        failureOrCaseDetails.fold(
          (failure) => emit(DoctorFailure(message: failure.message)),
          (response) => emit(DoctorSuccessCaseDetails(
            diagnosedDisease: response.$1,
            patient: response.$2,
            disease: response.$3,
          )),
        );
      },
    );

    on<DoctorUpdateCase>(
      (event, emit) async {
        emit(DoctorLoading());
        final failureOrCaseDetails = await _doctorUpdateCaseDetails(
          DoctorUpdateCaseDetailsParams(
            diagnosedDisease: event.diagnosedDisease,
          ),
        );
        failureOrCaseDetails.fold(
          (failure) => emit(DoctorFailure(message: failure.message)),
          (response) => emit(DoctorSuccessCaseDetails(
            diagnosedDisease: response.$1,
            patient: response.$2,
            disease: response.$3,
          )),
        );
      },
    );

    on<DoctorAppointments>(
      (event, emit) async {
        emit(DoctorLoading());
        final failureOrAppointments = await _doctorGetAppointments(
          DoctorGetAppointmentsParams(
            doctorID: event.doctorID,
            diagnosedID: event.diagnosedID,
          ),
        );
        failureOrAppointments.fold(
          (failure) => emit(DoctorFailure(message: failure.message)),
          (response) => emit(DoctorSuccessAppointments(
            appointments: response,
          )),
        );
      },
    );

    on<DoctorCancelAppointment>(
      (event, emit) async {
        emit(DoctorLoading());
        final failureOrAppointments = await _doctorCancelAppointment(
          usecasecancel.DoctorCancelAppointmentParams(
            appointmentID: event.appointmentID,
          ),
        );
        failureOrAppointments.fold(
          (failure) => emit(DoctorFailure(message: failure.message)),
          (response) => emit(DoctorSuccess()),
        );
      },
    );

    on<DoctorAvailableSlot>(
      (event, emit) async {
        emit(DoctorLoading());
        final failureOrAppointments = await _doctorGetAvailableAppointmentSlots(
          DoctorGetAvailableAppointmentSlotsParams(
            doctorID: event.doctorID,
            patientID: event.patientID,
          ),
        );
        failureOrAppointments.fold(
          (failure) => emit(DoctorFailure(message: failure.message)),
          (response) => emit(DoctorSuccessAvailableSlot(
            availableSlots: response,
          )),
        );
      },
    );

    on<DoctorUpdateAppointment>(
      (event, emit) async {
        emit(DoctorLoading());
        final failureOrAppointments = await _doctorUpdateAppointment(
          usecaseupdate.DoctorUpdateAppointmentParams(
              appointment: event.appointment, insert: event.insert),
        );
        failureOrAppointments.fold(
          (failure) => emit(DoctorFailure(message: failure.message)),
          (response) => emit(DoctorSuccessAppointment(
            response: response,
          )),
        );
      },
    );

    on<DoctorSignOut>(
      (event, emit) async {
        final failureOrSuccess = await _doctorSignOut(NoParams());
        failureOrSuccess.fold(
          (failure) => emit(DoctorFailure(message: failure.message)),
          (_) => emit(DoctorSuccessSignOut()),
        );
      },
    );

    on<DoctorConnectStreamEvent>(
      (event, emit) async {
        final successOrFailure = await _doctorConnectStream(
          DoctorConnectStreamParams(id: event.id, name: event.name));
      successOrFailure.fold(
        (failure) => emit(DoctorSuccess()),
        (_) => emit(DoctorSuccess()),
      );
      },
    );

    on<DoctorCallPatientEvent>((event, emit) async {

      final failureOrSuccess = await _doctorCallPatient(
        DoctorCallPatientParams(
          appointmentID: event.appointmentID,
        ),
      );
      failureOrSuccess.fold(
        (failure) => emit(DoctorFailure(message: failure.message)),
        (response) => emit(DoctorSuccessCallPatient(call: response)),
      ); 
    });
  }
}
