import 'package:dermai/features/core/entities/appointment.dart';
import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/entities/patient.dart';
import 'package:dermai/features/core/error/exception.dart';
import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/doctor/data/data_sources/doctor_remote_data_source.dart';
import 'package:dermai/features/doctor/data/models/appointment_model.dart';
import 'package:dermai/features/doctor/data/models/diagnosed_disease_model.dart';
import 'package:dermai/features/doctor/domain/repository/doctor_repository.dart';
import 'package:fpdart/src/either.dart';
import 'package:stream_video/src/call/call.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final DoctorRemoteDataSource remoteDataSource;
  const DoctorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<(DiagnosedDisease, Patient, Disease)>>> getCases(
      {required String doctorID}) async {
    try {
      final response = await remoteDataSource.getCases(doctorID: doctorID);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, (DiagnosedDisease, Patient, Disease)>> getCaseDetails(
      {required String diagnosedID}) async {
    try {
      final response =
          await remoteDataSource.getCaseDetails(diagnosedID: diagnosedID);
      return right(response);
    } on ServerException catch (e) {
      throw left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, (DiagnosedDisease, Patient, Disease)>> updateCase(
      {required DiagnosedDisease diagnosedDisease}) async {
    try {
      final response = await remoteDataSource.updateCaseDetails(
          diagnosedDisease: DiagnosedDiseaseModel(
              diagnosedID: diagnosedDisease.diagnosedID,
              picture: diagnosedDisease.picture,
              diseaseID: diagnosedDisease.diseaseID,
              patientID: diagnosedDisease.patientID,
              doctorID: diagnosedDisease.doctorID,
              dateCreated: diagnosedDisease.dateCreated,
              dateDiagnosed: diagnosedDisease.dateDiagnosed,
              details: diagnosedDisease.details,
              patientsComment: diagnosedDisease.patientsComment,
              doctorsComment: diagnosedDisease.doctorsComment,
              editedByDoctor: diagnosedDisease.editedByDoctor,
              prescription: diagnosedDisease.prescription,
              status: diagnosedDisease.status,
              diagnosedDiseaseName: diagnosedDisease.diagnosedDiseaseName));
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<
          Either<Failure,
              List<(Appointment, DiagnosedDisease, Patient, Disease)>>>
      getAppointments({required String doctorID, String? patientID, String? diagnosedID}) async {
    try {
      final response = await remoteDataSource.getAppointments(
          doctorID: doctorID, patientID: patientID, diagnosedID: diagnosedID);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> cancelAppointment(
      {required String appointmentID}) async {
    try {
      final response = await remoteDataSource.cancelAppointment(
          appointmentID: appointmentID);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, (Appointment, DiagnosedDisease, Patient, Disease)>>
      updateAppointment(
          {required Appointment appointment, required bool insert}) async {
    try {
      final response = await remoteDataSource.updateAppointment(
          appointment: AppointmentModel(
            appointmentID: appointment.appointmentID,
            dateCreated: appointment.dateCreated,
            status: appointment.status,
            comment: appointment.comment,
            description: appointment.description,
            diagnosedID: appointment.diagnosedID,
            isPhysical: appointment.isPhysical,
          ),
          insert: insert);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
  
  @override
  Future<Either<Failure, void>> signOut() {
    return remoteDataSource.signOut().then((_) => right(null));
  }

  @override
  Future<Either<Failure, Call>> callPatient({required String appointmentID}) async {
    try {
      final response = await remoteDataSource.callPatient(appointmentID: appointmentID);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> connectStream({required String id, required String name}) async {
    try {
      final response = await remoteDataSource.connectStream(id: id, name: name);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
