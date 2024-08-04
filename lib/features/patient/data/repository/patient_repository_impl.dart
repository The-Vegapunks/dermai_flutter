import 'package:dermai/features/core/entities/appointment.dart';
import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/entities/doctor.dart';
import 'package:dermai/features/core/entities/message.dart';
import 'package:dermai/features/core/error/exception.dart';
import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/patient/data/data_sources/patient_remote_data_source.dart';
import 'package:dermai/features/patient/data/models/message_model.dart';
import 'package:dermai/features/patient/domain/repository/patient_repository.dart';
import 'package:fpdart/src/either.dart';
import 'package:stream_video/src/call/call.dart';

class PatientRepositoryImpl implements PatientRepository {
  final PatientRemoteDataSource remoteDataSource;

  const PatientRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<(DiagnosedDisease, Disease, Doctor?)>>>
      getDiagnosedDiseases({required String patientID}) async {
    try {
      final response =
          await remoteDataSource.getDiagnosedDiseases(patientID: patientID);
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
  Future<
          Either<Failure,
              List<(Appointment, DiagnosedDisease, Doctor, Disease)>>>
      getAppointments(
          {required String patientID,
          String? doctorID,
          String? diagnosedID}) async {
    try {
      final response = await remoteDataSource.getAppointments(
          patientID: patientID, doctorID: doctorID, diagnosedID: diagnosedID);
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
  Future<Either<Failure, (DiagnosedDisease, Disease)>> submitCase(
      {required String imagePath, required String patientComment}) async {
    try {
      final response = await remoteDataSource.submitCase(
          imagePath: imagePath, patientComment: patientComment);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Stream<List<Message>> getMessages({required String diagnosedID}) {
    return remoteDataSource.getMessages(diagnosedID: diagnosedID);
  }

  @override
  Future<Either<Failure, void>> sendMessage(
      {required String diagnosedID,
      required String diseaseName,
      required List<Message> previousMessages}) async {
    try {
      final response = await remoteDataSource.sendMessage(
          diagnosedID: diagnosedID,
          diseaseName: diseaseName,
          previousMessages: previousMessages
              .map((e) => MessageModel(
                  messageID: e.messageID,
                  message: e.message,
                  dateTime: e.dateTime,
                  isGenerated: e.isGenerated,
                  diagnosedID: diagnosedID))
              .toList());
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Call>> callDoctor(
      {required String appointmentID}) async {
    try {
      final response =
          await remoteDataSource.callDoctor(appointmentID: appointmentID);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> connectStream(
      {required String id, required String name}) async {
    try {
      final response = await remoteDataSource.connectStream(id: id, name: name);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
