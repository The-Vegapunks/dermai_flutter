import 'package:dermai/features/core/error/exception.dart';
import 'package:dermai/features/doctor/data/models/appointment_model.dart';
import 'package:dermai/features/doctor/data/models/diagnosed_disease_model.dart';
import 'package:dermai/features/doctor/data/models/disease_model.dart';
import 'package:dermai/features/doctor/data/models/patient_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
          )>> getAppointments({required String doctorID, String? patientID});
  Future<(DiagnosedDiseaseModel, PatientModel, DiseaseModel)> getCaseDetails(
      {required String diagnosedID});
  Future<(DiagnosedDiseaseModel, PatientModel, DiseaseModel)> updateCaseDetails(
      {required DiagnosedDiseaseModel diagnosedDisease});
  Future<void> cancelAppointment({required String appointmentID});
  Future<(AppointmentModel, DiagnosedDiseaseModel, PatientModel, DiseaseModel)>
      updateAppointment({required AppointmentModel appointment});
}

class DoctorRemoteDataSourceImpl implements DoctorRemoteDataSource {
  final SupabaseClient client;
  DoctorRemoteDataSourceImpl({required this.client});

  @override
  Future<List<(DiagnosedDiseaseModel, PatientModel, DiseaseModel)>> getCases(
      {required String doctorID}) async {
    try {
      // client.auth.signUp(email: "doctor1@test.io", password: "123456", data: {
      //   'name': "Dr. Sarah Johnson",
      //   'isDoctor': true,
      // });
      // client.auth.signUp(email: "doctor2@test.io", password: "123456", data: {
      //   'name': "Dr. John Doe",
      //   'isDoctor': true,
      // });

      final response = await client
          .from('diagnosedDisease')
          .select('''*, disease( * ), patient!inner( * )''')
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
          )>> getAppointments({required String doctorID, String? patientID}) async {
    try {
      final response = patientID == null ? await client
          .from('appointment')
          .select('''*, diagnosedDisease( *, disease( * ), patient( * ) )''')
          .eq('diagnosedDisease.doctorID', doctorID)
          .order('dateCreated', ascending: true) :
          await client
          .from('appointment')
          .select('''*, diagnosedDisease( *, disease( * ), patient( * ) )''')
          .or('doctorID.eq.$doctorID, patientID.eq.$patientID', referencedTable: 'diagnosedDisease')
          .order('dateCreated', ascending: true);
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
      updateAppointment({required AppointmentModel appointment}) async {
    try {
      final response = await client
          .from('appointment')
          .update(appointment.toJson())
          .match({'appointmentID': appointment.appointmentID})
          .eq('appointmentID', appointment.appointmentID)
          .select('''*, diagnosedDisease( *, disease( * ), patient( * ) )''')
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
}
