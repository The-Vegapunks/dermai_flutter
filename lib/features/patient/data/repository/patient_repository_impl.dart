import 'package:dermai/features/patient/data/data_sources/patient_remote_data_source.dart';
import 'package:dermai/features/patient/domain/repository/patient_repository.dart';

class PatientRepositoryImpl implements PatientRepository {
  final PatientRemoteDataSource remoteDataSource;

  const PatientRepositoryImpl({required this.remoteDataSource});
}