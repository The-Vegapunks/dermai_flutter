import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/doctor/domain/usecases/doctor_get_diagnosed_diseases.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class DoctorRepository {
  Future<Either<Failure, List<DiagnosedDisease>>> getListOfDiagnosedDisease({ required String doctorID, required CasesType casesType});

}