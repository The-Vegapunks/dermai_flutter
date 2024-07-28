import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/core/usecase/usecase.dart';
import 'package:dermai/features/doctor/domain/repository/doctor_repository.dart';
import 'package:fpdart/fpdart.dart';

class DoctorCancelAppointment implements UseCase<void, DoctorCancelAppointmentParams> {
  final DoctorRepository caseRepository;

  DoctorCancelAppointment(this.caseRepository);

  @override
  Future<Either<Failure, void>> call(DoctorCancelAppointmentParams params) async {
    return await caseRepository.cancelAppointment(appointmentID: params.appointmentID);
  }  
}

class DoctorCancelAppointmentParams {
  final String appointmentID;

  DoctorCancelAppointmentParams({required this.appointmentID});
}