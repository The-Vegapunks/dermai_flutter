import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/core/usecase/usecase.dart';
import 'package:dermai/features/doctor/domain/repository/doctor_repository.dart';
import 'package:fpdart/fpdart.dart';

class DoctorGetCases implements UseCase<List<DiagnosedDisease>, DoctorGetCasesParams> {
  final DoctorRepository repository;

  DoctorGetCases(this.repository);

  @override
  Future<Either<Failure, List<DiagnosedDisease>>> call(DoctorGetCasesParams params) async {
    return await repository.getCases(doctorID: params.doctorID);
  }
}

class DoctorGetCasesParams {
  final String doctorID;
  final CasesType casesType;

  DoctorGetCasesParams({required this.doctorID, required this.casesType});

}

enum CasesType {
  all(caseName: 'All'),
  current(caseName: 'Current'),
  available(caseName: 'Available'),
  completed(caseName: 'Completed'),;

  final String caseName;

  const CasesType({required this.caseName});
}