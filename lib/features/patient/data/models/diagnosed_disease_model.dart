import 'package:dermai/features/core/entities/diagnosed_disease.dart';

class DiagnosedDiseaseModel extends DiagnosedDisease {
  DiagnosedDiseaseModel({
    super.diagnosedID,
    required super.picture,
    required super.diseaseID,
    required super.patientID,
    required super.doctorID,
    required super.dateCreated,
    required super.dateDiagnosed,
    required super.details,
    required super.patientsComment,
    required super.doctorsComment,
    required super.editedByDoctor,
    required super.prescription,
    required super.status,
    required super.diagnosedDiseaseName,
  });

  factory DiagnosedDiseaseModel.fromJson(Map<String, dynamic> json) {
    return DiagnosedDiseaseModel(
      diagnosedID: json['diagnosedID'],
      picture: json['picture'],
      diseaseID: json['diseaseID'],
      patientID: json['patientID'],
      doctorID: json['doctorID'],
      dateCreated: DateTime.parse(json['dateCreated']),
      dateDiagnosed: json['dateDiagnosed'] != null
          ? DateTime.parse(json['dateDiagnosed'])
          : null,
      details: json['details'],
      patientsComment: json['patientsComment'],
      doctorsComment: json['doctorsComment'],
      editedByDoctor: json['editedByDoctor'],
      prescription: json['prescription'],
      status: json['status'],
      diagnosedDiseaseName: json['diagnosedDiseaseName'],
    );
  }
}
