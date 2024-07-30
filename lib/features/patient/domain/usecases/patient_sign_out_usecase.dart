import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/core/usecase/usecase.dart';
import 'package:dermai/features/patient/domain/repository/patient_repository.dart';
import 'package:fpdart/fpdart.dart';

class PatientSignOutUsecase implements UseCase<void, NoParams> {
  final PatientRepository repository;

  PatientSignOutUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.signOut();
  }
}

class NoParams {}