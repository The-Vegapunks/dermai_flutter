import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/doctor/domain/usecases/doctor_get_case_details.dart';
import 'package:dermai/features/doctor/domain/usecases/doctor_get_cases.dart';
import 'package:dermai/features/doctor/domain/usecases/doctor_update_case_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'doctor_event.dart';
part 'doctor_state.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  final DoctorGetCases _doctorGetDiagnosedDiseases;
  final DoctorGetCaseDetails _doctorGetCaseDetails;
  final DoctorUpdateCaseDetails _doctorUpdateCaseDetails;
  DoctorBloc({
    required DoctorGetCases doctorGetDiagnosedDiseases,
    required DoctorGetCaseDetails doctorGetCaseDetails,
    required DoctorUpdateCaseDetails doctorUpdateCaseDetails,
  })  : _doctorGetDiagnosedDiseases = doctorGetDiagnosedDiseases,
        _doctorGetCaseDetails = doctorGetCaseDetails,
        _doctorUpdateCaseDetails = doctorUpdateCaseDetails,
        super(DoctorInitial()) {
    on<DoctorDiagnosedDisease>((event, emit) async {
      emit(DoctorLoading());

      final failureOrDiseases = await _doctorGetDiagnosedDiseases(
        DoctorGetCasesParams(
          doctorID: event.doctorID,
          casesType: event.casesType,
        ),
      );
      failureOrDiseases.fold(
        (failure) => emit(DoctorFailure(message: failure.message)),
        (diagnosedDiseases) => emit(DoctorSuccessListOfDiagnosedDisease(
            diagnosedDiseases: diagnosedDiseases)),
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
          (diagnosedDisease) => emit(DoctorSuccessCaseDetails(
            diagnosedDisease: diagnosedDisease,
          )),
        );
      },
    );

    on<DoctorUpdateCase>(
      (event, emit) async {
        final failureOrCaseDetails = await _doctorUpdateCaseDetails(
          DoctorUpdateCaseDetailsParams(
            diagnosedDisease: event.diagnosedDisease,
          ),
        );
        failureOrCaseDetails.fold(
          (failure) => emit(DoctorFailure(message: failure.message)),
          (diagnosedDisease) => emit(DoctorSuccessCaseDetails(
            diagnosedDisease: diagnosedDisease,
          )),
        );
      },
    );
  }
}
