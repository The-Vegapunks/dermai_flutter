import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/entities/doctor.dart';
import 'package:dermai/features/patient/domain/usecases/patient_get_diagnosed_diseases.dart';
import 'package:dermai/features/patient/domain/usecases/patient_sign_out_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'patient_event.dart';
part 'patient_state.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final PatientGetDiagnosedDiseases _patientGetDiagnosedDiseases;
  final PatientSignOutUsecase _patientSignOut;

  PatientBloc({
    required PatientGetDiagnosedDiseases patientGetDiagnosedDiseases,
    required PatientSignOutUsecase patientSignOut,
  })  : _patientGetDiagnosedDiseases = patientGetDiagnosedDiseases,
        _patientSignOut = patientSignOut,
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
  }  
}
