import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/entities/doctor.dart';
import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/patient/data/data_sources/patient_remote_data_source.dart';
import 'package:dermai/features/patient/domain/repository/patient_repository.dart';
import 'package:fpdart/src/either.dart';

class PatientRepositoryImpl implements PatientRepository {
  final PatientRemoteDataSource remoteDataSource;

  const PatientRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<(DiagnosedDisease, Disease, Doctor)>>> getDiagnosedDiseases({required String patientID}) async {
    try {
      final response = await remoteDataSource.getDiagnosedDiseases(patientID: patientID);
      return right(response);
    } on Exception catch (e) {
      return left(Failure(e.toString()));
    }
  }
}