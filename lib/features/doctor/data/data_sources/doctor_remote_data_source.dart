import 'package:dermai/features/core/error/exception.dart';
import 'package:dermai/features/doctor/data/models/diagnosed_disease_model.dart';
import 'package:dermai/features/doctor/domain/usecases/doctor_get_diagnosed_diseases.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class DoctorRemoteDataSource {
  Future<List<DiagnosedDiseaseModel>> getCases(
      {required String doctorID, required CasesType casesType});

  // Future<UserModel> signIn({required String email, required String password});
  // Future<UserModel> signUp({required String name, required String email, required String password});
}

class DoctorRemoteDataSourceImpl implements DoctorRemoteDataSource {
  final SupabaseClient client;
  DoctorRemoteDataSourceImpl({required this.client});

  @override
  Future<List<DiagnosedDiseaseModel>> getCases(
      {required String doctorID, required CasesType casesType}) async {
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
          .select('''*, disease( name ), patient!inner( name )''')
          .isFilter('status', casesType == CasesType.completed)
          .or(casesType == CasesType.all
              ? 'doctorID.is.null,doctorID.eq.$doctorID'
              : casesType == CasesType.current
                  ? 'doctorID.eq.$doctorID'
                  : casesType == CasesType.available
                      ? 'doctorID.is.null'
                      : 'doctorID.eq.$doctorID')
          .order('doctorID', nullsFirst: true)
          .order('dateCreated', ascending: true);

      if (response.isEmpty) return [];
      return response.map((e) => DiagnosedDiseaseModel.fromJson(e)).toList();
    } catch (e) {
      throw const ServerException(
          'An error occurred while fetching diagnosed diseases');
    }
  }
}
