import 'package:dermai/features/core/entities/appointment.dart';
import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/entities/patient.dart';
import 'package:dermai/features/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' as stream;

abstract interface class DoctorRepository {
  Future<Either<Failure, List<(DiagnosedDisease, Patient, Disease)>>> getCases({ required String doctorID});
  Future<Either<Failure, (DiagnosedDisease, Patient, Disease)>> getCaseDetails({ required String diagnosedID});
  Future<Either<Failure, (DiagnosedDisease, Patient, Disease)>> updateCase({ required DiagnosedDisease diagnosedDisease});
  Future<Either<Failure, List<(Appointment, DiagnosedDisease, Patient, Disease)>>> getAppointments({ required String doctorID, String? patientID, String? diagnosedID});
  Future<Either<Failure, void>> cancelAppointment({ required String appointmentID});
  Future<Either<Failure, (Appointment, DiagnosedDisease, Patient, Disease)>> updateAppointment({ required Appointment appointment, required bool insert});
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, void>> connectStream({required String id, required String name});
  Future<Either<Failure, stream.Call>> callPatient({required String patientID, required String appointmentID});
}