import 'package:dermai/features/core/entities/appointment.dart';
import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/entities/doctor.dart';
import 'package:dermai/features/patient/domain/usecases/patient_get_appointments.dart';
import 'package:dermai/features/patient/domain/usecases/patient_get_diagnosed_diseases.dart';
import 'package:dermai/features/patient/domain/usecases/patient_sign_out_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import "package:collection/collection.dart";


part 'patient_event.dart';
part 'patient_state.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final PatientGetDiagnosedDiseases _patientGetDiagnosedDiseases;
  final PatientSignOutUsecase _patientSignOut;
  final PatientGetAppointments _patientGetAppointments;

  PatientBloc({
    required PatientGetDiagnosedDiseases patientGetDiagnosedDiseases,
    required PatientSignOutUsecase patientSignOut,
    required PatientGetAppointments patientGetAppointments,
  })  : _patientGetDiagnosedDiseases = patientGetDiagnosedDiseases,
        _patientSignOut = patientSignOut,
        _patientGetAppointments = patientGetAppointments,
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
        (response) => emit(PatientSuccessDiagnosedDiseases(
            diagnosedDiseases: response)),
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
        ),
      );
      failureOrAppointments.fold(
        (failure) => emit(PatientFailure(message: failure.message)),
        (response) => emit(PatientSuccessAppointments(appointments: groupBy(response, (element) => DateTime(element.$1.dateCreated.year, element.$1.dateCreated.month, element.$1.dateCreated.day)))),
      );
    });
  }  
}
