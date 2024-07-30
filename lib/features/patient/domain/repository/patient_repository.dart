import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/entities/doctor.dart';
import 'package:dermai/features/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class PatientRepository {
  Future<Either<Failure, List<(DiagnosedDisease, Disease, Doctor)>>> getDiagnosedDiseases({required String patientID});
}