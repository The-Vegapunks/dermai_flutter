import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/error/exception.dart';
import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/doctor/data/data_sources/doctor_remote_data_source.dart';
import 'package:dermai/features/doctor/data/models/diagnosed_disease_model.dart';
import 'package:dermai/features/doctor/domain/repository/doctor_repository.dart';
import 'package:dermai/features/doctor/domain/usecases/doctor_get_cases.dart';
import 'package:fpdart/src/either.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final DoctorRemoteDataSource remoteDataSource;
  const DoctorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<DiagnosedDisease>>> getCases(
      {required String doctorID, required CasesType casesType}) async {
    try {
      final diagnosedDiseases = await remoteDataSource.getCases(
          doctorID: doctorID, casesType: casesType);
      return right(diagnosedDiseases);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, DiagnosedDisease>> getCaseDetails(
      {required String diagnosedID}) async {
    try {
      final diagnosedDisease =
          await remoteDataSource.getCaseDetails(diagnosedID: diagnosedID);
      return right(diagnosedDisease);
    } on ServerException catch (e) {
      throw left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, DiagnosedDisease>> updateCase(
      {required DiagnosedDisease diagnosedDisease}) async {
    try {
      final updatedDiagnosedDisease = await remoteDataSource.updateCaseDetails(
          diagnosedDisease: DiagnosedDiseaseModel(
              diagnosedID: diagnosedDisease.diagnosedID,
              picture: diagnosedDisease.picture,
              diseaseID: diagnosedDisease.diseaseID,
              patientID: diagnosedDisease.patientID,
              doctorID: diagnosedDisease.doctorID,
              dateCreated: diagnosedDisease.dateCreated,
              dateDiagnosed: diagnosedDisease.dateDiagnosed,
              details: diagnosedDisease.details,
              patientsComment: diagnosedDisease.patientsComment,
              doctorsComment: diagnosedDisease.doctorsComment,
              editedByDoctor: diagnosedDisease.editedByDoctor,
              prescription: diagnosedDisease.prescription,
              status: diagnosedDisease.status,
              patientName: diagnosedDisease.patientName,
              diseaseName: diagnosedDisease.diseaseName));
      return right(updatedDiagnosedDisease);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
