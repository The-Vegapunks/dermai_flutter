import 'dart:io';

import 'package:dermai/features/core/error/exception.dart';
import 'package:dermai/features/patient/data/models/appointment_model.dart';
import 'package:dermai/features/patient/data/models/diagnosed_disease_model.dart';
import 'package:dermai/features/patient/data/models/disease_model.dart';
import 'package:dermai/features/patient/data/models/doctor_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as developer;

abstract interface class PatientRemoteDataSource {
  Future<List<(DiagnosedDiseaseModel, DiseaseModel, DoctorModel)>>
      getDiagnosedDiseases({required String patientID});
  Future<
      List<
          (
            AppointmentModel,
            DiagnosedDiseaseModel,
            DoctorModel,
            DiseaseModel
          )>> getAppointments({required String patientID, String? doctorID});
  Future<void> signOut();
}

class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  final SupabaseClient client;
  PatientRemoteDataSourceImpl({required this.client});

  @override
  Future<List<(DiagnosedDiseaseModel, DiseaseModel, DoctorModel)>>
      getDiagnosedDiseases({required String patientID}) async {
    try {
      final response = await client
          .from('diagnosedDisease')
          .select('''*, disease( * ), doctor( * )''')
          .eq('patientID', patientID)
          .order('dateCreated', ascending: false);

      if (response.isEmpty) return [];
      return response
          .map((e) => (
                DiagnosedDiseaseModel.fromJson(e),
                DiseaseModel.fromJson(e['disease']),
                DoctorModel.fromJson(e['doctor'])
              ))
          .toList();
    } catch (e) {
      throw const ServerException("An error occurred while fetching data");
    }
  }

  @override
  Future<void> signOut() {
    return client.auth.signOut();
  }
  
  @override
  Future<List<(AppointmentModel, DiagnosedDiseaseModel, DoctorModel, DiseaseModel)>> getAppointments({required String patientID, String? doctorID}) async {
    try {
      DateTime now = DateTime.now();
            final response = doctorID == null
          ? await client
              .from('appointment')
              .select(
                  '''*, diagnosedDisease!inner( *, disease( * ), doctor( * ) )''')
              .eq('diagnosedDisease.patientID', patientID)
              .gte('dateCreated', DateTime(now.year, now.month, now.day).toIso8601String())
              .order('dateCreated', ascending: true)
          : await client
              .from('appointment')
              .select(
                  '''*, diagnosedDisease( *, disease( * ), doctor( * ) )''')
              .or('doctorID.eq.$doctorID, patientID.eq.$patientID',
                  referencedTable: 'diagnosedDisease')
              .order('dateCreated', ascending: true);
              

      if (response.isEmpty) return [];      
      return response
          .map((e) => (
                AppointmentModel.fromJson(e),
                DiagnosedDiseaseModel.fromJson(e['diagnosedDisease']),
                DoctorModel.fromJson(e['diagnosedDisease']['doctor']),
                DiseaseModel.fromJson(e['diagnosedDisease']['disease'])
              ))
          .toList();
    } catch (e) {
      throw const ServerException(
          'An error occurred while fetching appointments');
    }
  }
}
