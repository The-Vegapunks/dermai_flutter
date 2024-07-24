
import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/error/exception.dart';
import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/doctor/data/data_sources/doctor_remote_data_source.dart';
import 'package:dermai/features/doctor/domain/repository/doctor_repository.dart';
import 'package:dermai/features/doctor/domain/usecases/doctor_get_diagnosed_diseases.dart';
import 'package:fpdart/src/either.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final DoctorRemoteDataSource remoteDataSource;
  const DoctorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<DiagnosedDisease>>> getListOfDiagnosedDisease({required String doctorID, required CasesType casesType}) async {
    try {
      final diagnosedDiseases = await remoteDataSource.getCases(doctorID: doctorID, casesType: casesType);
      return right(diagnosedDiseases);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }

  }


}