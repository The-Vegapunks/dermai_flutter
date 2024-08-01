

import 'package:dermai/features/core/entities/appointment.dart';
import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/entities/doctor.dart';
import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/core/usecase/usecase.dart';
import 'package:dermai/features/patient/domain/repository/patient_repository.dart';
import 'package:fpdart/fpdart.dart';

class PatientGetAppointments implements UseCase<List<(Appointment, DiagnosedDisease, Doctor, Disease)>, PatientGetAppointmentsParams> {
  final PatientRepository repository;

  PatientGetAppointments(this.repository);

  @override
  Future<Either<Failure, List<(Appointment, DiagnosedDisease, Doctor, Disease)>>>
      call(PatientGetAppointmentsParams params) async {
    return await repository.getAppointments(patientID: params.patientID, doctorID: params.doctorID);
  }
}

class PatientGetAppointmentsParams {
  final String patientID;
  final String? doctorID;

  PatientGetAppointmentsParams({required this.patientID, this.doctorID});
}