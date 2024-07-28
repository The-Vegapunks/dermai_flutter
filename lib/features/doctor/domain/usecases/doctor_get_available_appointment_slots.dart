import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/core/usecase/usecase.dart';
import 'package:dermai/features/doctor/domain/repository/doctor_repository.dart';
import 'package:flutter_neat_and_clean_calendar/neat_and_clean_calendar_event.dart';
import 'package:fpdart/fpdart.dart';

class DoctorGetAvailableAppointmentSlots
    implements
        UseCase<List<NeatCleanCalendarEvent>,
            DoctorGetAvailableAppointmentSlotsParams> {
  final DoctorRepository repository;

  DoctorGetAvailableAppointmentSlots(this.repository);

  @override
  Future<Either<Failure, List<NeatCleanCalendarEvent>>> call(
      DoctorGetAvailableAppointmentSlotsParams params) async {
    try {
      final bookedAppointmentsResult =
          await repository.getAppointments(doctorID: params.doctorID, patientID: params.patientID);
      if (bookedAppointmentsResult.isLeft()) {
        return Left(Failure('Failed to get available time slots'));
      }
      final bookedAppointments =
          bookedAppointmentsResult.getOrElse((failure) => []);

      DateTime nowWithTime = DateTime.now();
      DateTime now =
          DateTime(nowWithTime.year, nowWithTime.month, nowWithTime.day);
      final endDate = now.add(const Duration(days: 30));
      final List<NeatCleanCalendarEvent> allSlots = [];

      for (DateTime date = now;
          date.isBefore(endDate);
          date = date.add(const Duration(days: 1))) {
        if (date.weekday == DateTime.sunday) continue; // Skip Sundays

        for (int hour = 9; hour < 17; hour++) {
          final slot = DateTime(date.year, date.month, date.day, hour);
          allSlots.add(NeatCleanCalendarEvent(
            'Available Slot',
            startTime: slot,
            endTime: slot.add(const Duration(hours: 1)),
          ));
        }
      }

      // Subtract booked appointments from all slots
      final availableSlots = allSlots.where((slot) {
        return !bookedAppointments.any(
            (booked) => booked.$1.dateCreated.isAtSameMomentAs(slot.startTime));
      }).toList();

      return Right(availableSlots);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}

class DoctorGetAvailableAppointmentSlotsParams {
  final String doctorID;
  final String? patientID;

  DoctorGetAvailableAppointmentSlotsParams({required this.doctorID, required this.patientID});
}
