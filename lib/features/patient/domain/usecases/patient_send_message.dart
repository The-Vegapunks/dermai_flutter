import 'package:dermai/features/core/entities/message.dart';
import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/core/usecase/usecase.dart';
import 'package:dermai/features/patient/domain/repository/patient_repository.dart';
import 'package:fpdart/fpdart.dart';

class PatientSendMessage implements UseCase<void, PatientSendMessageParams> {
  final PatientRepository repository;

  PatientSendMessage(this.repository);

  @override
  Future<Either<Failure, void>> call(PatientSendMessageParams params) async {
    return await repository.sendMessage(diagnosedID: params.diagnosedID, diseaseName: params.diseaseName, previousMessages: params.previousMessages);
  }
}

class PatientSendMessageParams {
  final String diagnosedID;
  final String diseaseName;
  final List<Message> previousMessages;

  PatientSendMessageParams({required this.diagnosedID, required this.diseaseName, required this.previousMessages});
}