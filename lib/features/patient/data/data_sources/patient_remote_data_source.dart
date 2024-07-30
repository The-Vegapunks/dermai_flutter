import 'package:dermai/features/core/error/exception.dart';
import 'package:dermai/features/patient/data/models/diagnosed_disease_model.dart';
import 'package:dermai/features/patient/data/models/disease_model.dart';
import 'package:dermai/features/patient/data/models/doctor_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class PatientRemoteDataSource {
  Future<List<(DiagnosedDiseaseModel, DiseaseModel, DoctorModel)>> getDiagnosedDiseases({required String patientID});

}

class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  final SupabaseClient client;
  PatientRemoteDataSourceImpl({required this.client});
  
  @override
  Future<List<(DiagnosedDiseaseModel, DiseaseModel, DoctorModel)>> getDiagnosedDiseases({required String patientID}) async {
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

}