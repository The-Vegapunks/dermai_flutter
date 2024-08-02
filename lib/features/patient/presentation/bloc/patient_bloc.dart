import 'package:dermai/features/core/entities/appointment.dart';
import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/entities/doctor.dart';
import 'package:dermai/features/patient/domain/usecases/patient_cancel_appointment.dart';
import 'package:dermai/features/patient/domain/usecases/patient_get_appointments.dart';
import 'package:dermai/features/patient/domain/usecases/patient_get_diagnosed_diseases.dart';
import 'package:dermai/features/patient/domain/usecases/patient_sign_out_usecase.dart';
import 'package:dermai/features/patient/domain/usecases/patient_submit_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import "package:collection/collection.dart";

part 'patient_event.dart';
part 'patient_state.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final PatientGetDiagnosedDiseases _patientGetDiagnosedDiseases;
  final PatientSignOutUsecase _patientSignOut;
  final PatientGetAppointments _patientGetAppointments;
  final PatientSubmitCase _patientSubmitCase;
  final PatientCancelAppointment _patientCancelAppointment;

  PatientBloc({
    required PatientGetDiagnosedDiseases patientGetDiagnosedDiseases,
    required PatientSignOutUsecase patientSignOut,
    required PatientGetAppointments patientGetAppointments,
    required PatientSubmitCase patientSubmitCase,
    required PatientCancelAppointment patientCancelAppointment,
  })  : _patientGetDiagnosedDiseases = patientGetDiagnosedDiseases,
        _patientSignOut = patientSignOut,
        _patientGetAppointments = patientGetAppointments,
        _patientSubmitCase = patientSubmitCase,
        _patientCancelAppointment = patientCancelAppointment,
        super(PatientInitial()) {
    on<PatientDiagnosedDiseases>((event, emit) async {
      emit(PatientLoading());

      final failureOrDiseases = await _patientGetDiagnosedDiseases(
        PatientGetDiagnosedDiseasesParams(
          patientID: event.patientID,
        ),
      );
      failureOrDiseases.fold(
        (failure) => emit(PatientFailure(message: failure.message)),
        (response) =>
            emit(PatientSuccessDiagnosedDiseases(diagnosedDiseases: response)),
      );
    });

    on<PatientSignOut>((event, emit) async {
      final failureOrSuccess = await _patientSignOut(NoParams());
      failureOrSuccess.fold(
        (failure) => emit(PatientFailure(message: failure.message)),
        (_) => emit(PatientSuccessSignOut()),
      );
    });

    on<PatientAppointments>((event, emit) async {
      emit(PatientLoading());

      final failureOrAppointments = await _patientGetAppointments(
        PatientGetAppointmentsParams(
          patientID: event.patientID,
          doctorID: event.doctorID,
          diagnosedID: event.diagnosedID
        ),
      );
      failureOrAppointments.fold(
        (failure) => emit(PatientFailure(message: failure.message)),
        (response) => emit(PatientSuccessAppointments(
            appointments: groupBy(
                response,
                (element) => DateTime(
                    element.$1.dateCreated.year,
                    element.$1.dateCreated.month,
                    element.$1.dateCreated.day)))),
      );
    });

    on<PatientSubmitCaseEvent>((event, emit) async {
      emit(PatientLoading());

      final failureOrSuccess = await _patientSubmitCase(
        PatientSubmitCaseParams(
          imagePath: event.imagePath,
          patientComment: event.patientComment,
        ),
      );
      failureOrSuccess.fold(
        (failure) => emit(PatientFailure(message: failure.message)),
        (response) => emit(PatientSuccessSubmitCase(
            diagnosedDisease: response.$1, disease: response.$2)),
      );
    });

    on<PatientCancelAppointmentEvent>((event, emit) async {
      emit(PatientLoading());

      final failureOrSuccess = await _patientCancelAppointment(
          PatientCancelAppointmentParams(appointmentID: event.appointmentID));
      failureOrSuccess.fold(
        (failure) => emit(PatientFailure(message: failure.message)),
        (response) => emit(PatientSuccessCancelAppointment()),
      );
    });
  }
}
