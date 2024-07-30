import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class PatientRemoteDataSource {
  

}

class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  final SupabaseClient client;
  PatientRemoteDataSourceImpl({required this.client});

}