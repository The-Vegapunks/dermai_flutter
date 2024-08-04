import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/core/usecase/usecase.dart';
import 'package:dermai/features/patient/domain/repository/patient_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' as stream;

class PatientCallDoctor implements UseCase<stream.Call, PatientCallDoctorParams> {
  final PatientRepository repository;

  PatientCallDoctor(this.repository);

  @override
  Future<Either<Failure, stream.Call>> call(PatientCallDoctorParams params) async {
    return await repository.callDoctor(doctorID: params.doctorID, appointmentID: params.appointmentID);
  }
}

class PatientCallDoctorParams {
  final String doctorID;
  final String appointmentID;

  PatientCallDoctorParams({required this.doctorID, required this.appointmentID});
}