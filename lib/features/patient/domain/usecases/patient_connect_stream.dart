import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/core/usecase/usecase.dart';
import 'package:dermai/features/patient/domain/repository/patient_repository.dart';
import 'package:fpdart/fpdart.dart';

class PatientConnectStream implements UseCase<void, PatientConnectStreamParams> {
  final PatientRepository repository;

  PatientConnectStream(this.repository);

  @override
  Future<Either<Failure, void>> call(PatientConnectStreamParams params) async {
    return await repository.connectStream(id: params.id, name: params.name);
  }
}

class PatientConnectStreamParams {
  final String id;
  final String name;

  PatientConnectStreamParams({required this.id, required this.name});
}