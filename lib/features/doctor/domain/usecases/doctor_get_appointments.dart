import 'package:dermai/features/core/entities/appointment.dart';
import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/entities/patient.dart';
import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/core/usecase/usecase.dart';
import 'package:dermai/features/doctor/domain/repository/doctor_repository.dart';
import 'package:fpdart/fpdart.dart';

class DoctorGetAppointments implements UseCase<List<(Appointment, DiagnosedDisease, Patient, Disease)>, DoctorGetAppointmentsParams> {
  final DoctorRepository repository;

  DoctorGetAppointments(this.repository);

  @override
  Future<Either<Failure, List<(Appointment, DiagnosedDisease, Patient, Disease)>>> call(DoctorGetAppointmentsParams params) async {
    return await repository.getAppointments(doctorID: params.doctorID, patientID: null);
  }
}

class DoctorGetAppointmentsParams {
  final String doctorID;

  DoctorGetAppointmentsParams({required this.doctorID});

}