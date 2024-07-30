

import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/entities/doctor.dart';
import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/core/usecase/usecase.dart';
import 'package:dermai/features/patient/domain/repository/patient_repository.dart';
import 'package:fpdart/fpdart.dart';

class PatientGetDiagnosedDiseases implements UseCase<List<(DiagnosedDisease, Disease, Doctor)>, PatientGetDiagnosedDiseasesParams> {
  final PatientRepository repository;

  PatientGetDiagnosedDiseases(this.repository);

  @override
  Future<Either<Failure, List<(DiagnosedDisease, Disease, Doctor)>>> call(PatientGetDiagnosedDiseasesParams params) async {
    return await repository.getDiagnosedDiseases(patientID: params.patientID);
  }
}

class PatientGetDiagnosedDiseasesParams {
  final String patientID;

  PatientGetDiagnosedDiseasesParams({required this.patientID});

}