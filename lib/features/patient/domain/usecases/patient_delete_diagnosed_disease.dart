
import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/core/usecase/usecase.dart';
import 'package:dermai/features/patient/domain/repository/patient_repository.dart';
import 'package:fpdart/fpdart.dart';

class PatientDeleteDiagnosedDisease implements UseCase<void, PatientDeleteDiagnosedDiseaseParams> {
  final PatientRepository repository;

  PatientDeleteDiagnosedDisease(this.repository);

  @override
  Future<Either<Failure, void>> call(PatientDeleteDiagnosedDiseaseParams params) async {
    return await repository.deleteDiagnosedDisease(diagnosedID: params.diagnosedID);
  }
}

class PatientDeleteDiagnosedDiseaseParams {
  final String diagnosedID;

  PatientDeleteDiagnosedDiseaseParams({required this.diagnosedID});
}