import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/core/usecase/usecase.dart';
import 'package:dermai/features/patient/domain/repository/patient_repository.dart';
import 'package:fpdart/fpdart.dart';

class PatientSubmitCase implements UseCase<(DiagnosedDisease, Disease), PatientSubmitCaseParams> {
  final PatientRepository repository;

  PatientSubmitCase(this.repository);

  @override
  Future<Either<Failure, (DiagnosedDisease, Disease)>> call(PatientSubmitCaseParams params) async {
    return await repository.submitCase(imagePath: params.imagePath, patientComment: params.patientComment);
  }
}

class PatientSubmitCaseParams {
  final String imagePath;
  final String patientComment;

  PatientSubmitCaseParams({required this.imagePath, required this.patientComment});
}
