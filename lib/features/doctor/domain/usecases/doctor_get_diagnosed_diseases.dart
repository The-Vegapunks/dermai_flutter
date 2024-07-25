import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/core/usecase/usecase.dart';
import 'package:dermai/features/doctor/domain/repository/doctor_repository.dart';
import 'package:fpdart/fpdart.dart';

class DoctorGetDiagnosedDiseases implements UseCase<List<DiagnosedDisease>, DoctorGetDiagnosedDiseaseParams> {
  final DoctorRepository repository;

  DoctorGetDiagnosedDiseases(this.repository);

  @override
  Future<Either<Failure, List<DiagnosedDisease>>> call(DoctorGetDiagnosedDiseaseParams params) async {
    return await repository.getListOfDiagnosedDisease(doctorID: params.doctorID, casesType: params.casesType);
  }
}

class DoctorGetDiagnosedDiseaseParams {
  final String doctorID;
  final CasesType casesType;

  DoctorGetDiagnosedDiseaseParams({required this.doctorID, required this.casesType});

}

enum CasesType {
  all(caseName: 'All'),
  current(caseName: 'Current'),
  available(caseName: 'Available'),
  completed(caseName: 'Completed'),;

  final String caseName;

  const CasesType({required this.caseName});
}