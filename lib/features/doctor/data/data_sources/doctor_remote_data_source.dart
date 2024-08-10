import 'package:dermai/features/core/error/exception.dart';
import 'package:dermai/features/doctor/data/models/appointment_model.dart';
import 'package:dermai/features/doctor/data/models/diagnosed_disease_model.dart';
import 'package:dermai/features/doctor/data/models/disease_model.dart';
import 'package:dermai/features/doctor/data/models/patient_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' as stream;

abstract interface class DoctorRemoteDataSource {
  Future<List<(DiagnosedDiseaseModel, PatientModel, DiseaseModel)>> getCases(
      {required String doctorID});

  Future<
      List<
          (
            AppointmentModel,
            DiagnosedDiseaseModel,
            PatientModel,
            DiseaseModel
          )>> getAppointments(
      {required String doctorID, String? patientID, String? diagnosedID});
  Future<(DiagnosedDiseaseModel, PatientModel, DiseaseModel)> getCaseDetails(
      {required String diagnosedID});
  Future<(DiagnosedDiseaseModel, PatientModel, DiseaseModel)> updateCaseDetails(
      {required DiagnosedDiseaseModel diagnosedDisease});
  Future<void> cancelAppointment({required String appointmentID});
  Future<(AppointmentModel, DiagnosedDiseaseModel, PatientModel, DiseaseModel)>
      updateAppointment(
          {required AppointmentModel appointment, required bool insert});
  Future<void> signOut();
  Future<stream.Call> callPatient({required String appointmentID});

}

class DoctorRemoteDataSourceImpl implements DoctorRemoteDataSource {
  final SupabaseClient client;
  DoctorRemoteDataSourceImpl({required this.client});

  @override
  Future<stream.Call> callPatient({required String appointmentID}) async {
    try {
      final call = stream.StreamVideo.instance.makeCall(
          id: appointmentID, callType: stream.StreamCallType.defaultType());
      final result = await call.getOrCreate();
      if (result.isSuccess) {
        return call;
      } else {
        throw const ServerException(
            'An error occurred while calling the patient');
      }
    } catch (e) {
      throw const ServerException(
          'An error occurred while calling the patient');
    }
  }

  @override
  Future<List<(DiagnosedDiseaseModel, PatientModel, DiseaseModel)>> getCases(
      {required String doctorID}) async {
    try {
      final response = await client
          .from('diagnosedDisease')
          .select('''*, disease( * ), patient!inner( * )''')
          .or('doctorID.eq.$doctorID, doctorID.is.null')
          .order('doctorID', nullsFirst: true)
          .order('dateCreated', ascending: true);

      if (response.isEmpty) return [];
      return response
          .map((e) => (
                DiagnosedDiseaseModel.fromJson(e),
                PatientModel.fromJson(e['patient']),
                DiseaseModel.fromJson(e['disease'])
              ))
          .toList();
    } catch (e) {
      throw const ServerException(
          'An error occurred while fetching diagnosed diseases');
    }
  }

  @override
  Future<
      List<
          (
            AppointmentModel,
            DiagnosedDiseaseModel,
            PatientModel,
            DiseaseModel
          )>> getAppointments(
      {required String doctorID,
      String? patientID,
      String? diagnosedID}) async {
    try {
      DateTime now = DateTime.now();
      final response = diagnosedID != null
          ? await client
              .from('appointment')
              .select(
                  '''*, diagnosedDisease!inner( *, disease( * ), patient( * ) )''')
              .eq('diagnosedDisease.diagnosedID', diagnosedID)
              .order('dateCreated', ascending: true)
          : (patientID == null
              ? await client
                  .from('appointment')
                  .select(
                      '''*, diagnosedDisease!inner( *, disease( * ), patient( * ) )''')
                  .eq('diagnosedDisease.doctorID', doctorID)
                  .gte('dateCreated',
                      DateTime(now.year, now.month, now.day).toIso8601String())
                  .order('dateCreated', ascending: true)
              : await client
                  .from('appointment')
                  .select(
                      '''*, diagnosedDisease!inner( *, disease( * ), patient( * ) )''')
                  .or('doctorID.eq.$doctorID, patientID.eq.$patientID',
                      referencedTable: 'diagnosedDisease')
                  .order('dateCreated', ascending: true));
      if (response.isEmpty) return [];
      return response
          .map((e) => (
                AppointmentModel.fromJson(e),
                DiagnosedDiseaseModel.fromJson(e['diagnosedDisease']),
                PatientModel.fromJson(e['diagnosedDisease']['patient']),
                DiseaseModel.fromJson(e['diagnosedDisease']['disease'])
              ))
          .toList();
    } catch (e) {
      throw const ServerException(
          'An error occurred while fetching appointments');
    }
  }

  @override
  Future<(DiagnosedDiseaseModel, PatientModel, DiseaseModel)> getCaseDetails(
      {required String diagnosedID}) async {
    try {
      final response = await client
          .from('diagnosedDisease')
          .select('''*, disease( * ), patient!inner( * )''')
          .eq('diagnosedID', diagnosedID)
          .single();

      return (
        DiagnosedDiseaseModel.fromJson(response),
        PatientModel.fromJson(response['patient']),
        DiseaseModel.fromJson(response['disease'])
      );
    } catch (e) {
      throw const ServerException('An error occurred while the case details');
    }
  }

  @override
  Future<(DiagnosedDiseaseModel, PatientModel, DiseaseModel)> updateCaseDetails(
      {required DiagnosedDiseaseModel diagnosedDisease}) async {
    try {
      final response = await client
          .from('diagnosedDisease')
          .update(diagnosedDisease.toJson())
          .match({'diagnosedID': diagnosedDisease.diagnosedID!})
          .eq('diagnosedID', diagnosedDisease.diagnosedID!)
          .select('''*, disease( * ), patient!inner( * )''')
          .single();
      return (
        DiagnosedDiseaseModel.fromJson(response),
        PatientModel.fromJson(response['patient']),
        DiseaseModel.fromJson(response['disease'])
      );
    } catch (e) {
      throw const ServerException(
          'An error occurred while updating the case details');
    }
  }

  @override
  Future<void> cancelAppointment({required String appointmentID}) {
    try {
      return client
          .from('appointment')
          .delete()
          .match({'appointmentID': appointmentID});
    } catch (e) {
      throw const ServerException(
          'An error occurred while cancelling the appointment');
    }
  }

  @override
  Future<(AppointmentModel, DiagnosedDiseaseModel, PatientModel, DiseaseModel)>
      updateAppointment(
          {required AppointmentModel appointment, required bool insert}) async {
    try {
      if (insert) {
        await client
            .from('appointment')
            .update({'status': 'completed'})
            .eq('diagnosedID', appointment.diagnosedID)
            .lt('dateCreated', appointment.dateCreated.toIso8601String());
      }
      final response = insert
          ? await client
              .from('appointment')
              .insert(appointment.toJson(insert: true))
              .select(
                  '''*, diagnosedDisease( *, disease( * ), patient( * ) )''').single()
          : await client
              .from('appointment')
              .update(appointment.toJson(insert: false))
              .match({'appointmentID': appointment.appointmentID!})
              .eq('appointmentID', appointment.appointmentID!)
              .select(
                  '''*, diagnosedDisease( *, disease( * ), patient( * ) )''')
              .single();
      return (
        AppointmentModel.fromJson(response),
        DiagnosedDiseaseModel.fromJson(response['diagnosedDisease']),
        PatientModel.fromJson(response['diagnosedDisease']['patient']),
        DiseaseModel.fromJson(response['diagnosedDisease']['disease'])
      );
    } catch (e) {
      throw const ServerException(
          'An error occurred while updating the appointment');
    }
  }

  @override
  Future<void> signOut() async {
    await stream.StreamVideo.reset(disconnect: true);
    return await client.auth.signOut();
  }
}
