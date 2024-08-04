import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/core/usecase/usecase.dart';
import 'package:dermai/features/doctor/domain/repository/doctor_repository.dart';
import 'package:fpdart/fpdart.dart';

class DoctorConnectStream implements UseCase<void, DoctorConnectStreamParams> {
  final DoctorRepository repository;

  DoctorConnectStream(this.repository);

  @override
  Future<Either<Failure, void>> call(DoctorConnectStreamParams params) async {
    return await repository.connectStream(id: params.id, name: params.name);
  }
}

class DoctorConnectStreamParams {
  final String id;
  final String name;

  DoctorConnectStreamParams({required this.id, required this.name});
}