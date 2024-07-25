import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/doctor/domain/usecases/doctor_get_diagnosed_diseases.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'doctor_event.dart';
part 'doctor_state.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  final DoctorGetDiagnosedDiseases _doctorGetDiagnosedDiseases;
  DoctorBloc({required DoctorGetDiagnosedDiseases doctorGetDiagnosedDiseases})
      : _doctorGetDiagnosedDiseases = doctorGetDiagnosedDiseases,
        super(DoctorInitial()) {
    on<DoctorEvent>((event, emit) async {
      emit(DoctorLoading());

      final failureOrDiseases = await _doctorGetDiagnosedDiseases(
        DoctorGetDiagnosedDiseaseParams(
          doctorID: (event as DoctorDiagnosedDisease).doctorID,
          casesType: event.casesType,
        ),
      );
      failureOrDiseases.fold(
        (failure) => emit(DoctorFailure(message: failure.message)),
        (diagnosedDiseases) => emit(DoctorSuccessListOfDiagnosedDisease(
            diagnosedDiseases: diagnosedDiseases)),
      );
    });
  }
}
