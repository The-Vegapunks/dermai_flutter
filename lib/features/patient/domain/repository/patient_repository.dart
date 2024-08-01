import 'package:dermai/features/core/entities/appointment.dart';
import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/entities/doctor.dart';
import 'package:dermai/features/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class PatientRepository {
  Future<Either<Failure, List<(DiagnosedDisease, Disease, Doctor)>>> getDiagnosedDiseases({required String patientID});
  Future<Either<Failure, List<(Appointment, DiagnosedDisease, Doctor, Disease)>>> getAppointments({required String patientID, String? doctorID});
  Future<Either<Failure, void>> signOut();
}