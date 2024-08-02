import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/core/usecase/usecase.dart';
import 'package:dermai/features/patient/domain/repository/patient_repository.dart';
import 'package:fpdart/fpdart.dart';

class PatientCancelAppointment implements UseCase<void, PatientCancelAppointmentParams> {
  final PatientRepository caseRepository;

  PatientCancelAppointment(this.caseRepository);

  @override
  Future<Either<Failure, void>> call(PatientCancelAppointmentParams params) async {
    return await caseRepository.cancelAppointment(appointmentID: params.appointmentID);
  }  
}

class PatientCancelAppointmentParams {
  final String appointmentID;

  PatientCancelAppointmentParams({required this.appointmentID});
}