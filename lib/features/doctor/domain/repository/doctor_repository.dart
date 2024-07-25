import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/doctor/domain/usecases/doctor_get_cases.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class DoctorRepository {
  Future<Either<Failure, List<DiagnosedDisease>>> getCases({ required String doctorID, required CasesType casesType});

}