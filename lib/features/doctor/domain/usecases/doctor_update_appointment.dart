import 'package:dermai/features/core/entities/appointment.dart';
import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/entities/patient.dart';
import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/core/usecase/usecase.dart';
import 'package:dermai/features/doctor/domain/repository/doctor_repository.dart';
import 'package:fpdart/fpdart.dart';

class DoctorUpdateAppointment
    implements
        UseCase<(Appointment, DiagnosedDisease, Patient, Disease),
            DoctorUpdateAppointmentParams> {
  final DoctorRepository repository;

  DoctorUpdateAppointment(this.repository);

  @override
  Future<Either<Failure, (Appointment, DiagnosedDisease, Patient, Disease)>>
      call(DoctorUpdateAppointmentParams params) async {
    return await repository.updateAppointment(appointment: params.appointment, insert: params.insert);
  }
}

class DoctorUpdateAppointmentParams {
  final Appointment appointment;
  final bool insert;

  DoctorUpdateAppointmentParams({required this.appointment, required this.insert});
}
