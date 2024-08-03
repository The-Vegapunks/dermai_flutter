import 'package:dermai/features/core/entities/message.dart';
import 'package:dermai/features/core/usecase/usecase.dart';
import 'package:dermai/features/patient/domain/repository/patient_repository.dart';

class PatientGetMessages implements UseCaseStream<Stream<List<Message>>, PatientGetMessagesParams> {
  final PatientRepository repository;

  PatientGetMessages(this.repository);
  
  @override
  Stream<List<Message>> call(PatientGetMessagesParams params) {
    return repository.getMessages(diagnosedID: params.diagnosedID);
  }

}

class PatientGetMessagesParams {
  final String diagnosedID;

  PatientGetMessagesParams({required this.diagnosedID});
}