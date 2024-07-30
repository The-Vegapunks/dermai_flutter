import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/core/usecase/usecase.dart';
import 'package:dermai/features/doctor/domain/repository/doctor_repository.dart';
import 'package:fpdart/fpdart.dart';

class DoctorSignOutUsecase implements UseCase<void, NoParams> {
  final DoctorRepository repository;

  DoctorSignOutUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.signOut();
  }
}

class NoParams {}