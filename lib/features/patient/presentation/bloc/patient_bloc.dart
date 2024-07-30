import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/entities/doctor.dart';
import 'package:dermai/features/patient/domain/usecases/patient_get_diagnosed_diseases.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'patient_event.dart';
part 'patient_state.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final PatientGetDiagnosedDiseases _patientGetDiagnosedDiseases;

  PatientBloc({
    required PatientGetDiagnosedDiseases patientGetDiagnosedDiseases,
  })  : _patientGetDiagnosedDiseases = patientGetDiagnosedDiseases,
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
  }
}
