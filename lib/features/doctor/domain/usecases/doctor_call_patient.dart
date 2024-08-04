import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/core/usecase/usecase.dart';
import 'package:dermai/features/doctor/domain/repository/doctor_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' as stream;

class DoctorCallPatient implements UseCase<stream.Call, DoctorCallPatientParams> {
  final DoctorRepository repository;

  DoctorCallPatient(this.repository);

  @override
  Future<Either<Failure, stream.Call>> call(DoctorCallPatientParams params) async {
    return await repository.callPatient(patientID: params.patientID, appointmentID: params.appointmentID);
  }
}

class DoctorCallPatientParams {
  final String patientID;
  final String appointmentID;

  DoctorCallPatientParams({required this.patientID, required this.appointmentID});
}