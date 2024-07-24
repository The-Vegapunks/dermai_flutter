class DiagnosedDisease {
  const DiagnosedDisease({
    required this.diagnosedID,
    required this.diseaseID,
    required this.patientID,
    required this.doctorID,
    required this.dateCreated,
    required this.dateDiagnosed,
    required this.details,
    required this.patientsComment,
    required this.doctorsComment,
    required this.editedByDoctor,
    required this.prescription,
    required this.status,
    required this.patientName,
    required this.diseaseName,
  });

  final String? diagnosedID;
  final int diseaseID;
  final String patientID;
  final String? doctorID;
  final DateTime dateCreated;
  final DateTime? dateDiagnosed;
  final String details;
  final String patientsComment;
  final String doctorsComment;
  final bool editedByDoctor;
  final String prescription;
  final bool status;
  final String patientName;
  final String diseaseName;

  factory DiagnosedDisease.fromJson(Map<String, dynamic> json) {
    return DiagnosedDisease(
      diagnosedID: json['diagnosedID'],
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
      patientName: json['patient']['name'],
      diseaseName: json['disease']['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (diagnosedID != null) 'diagnosedID': diagnosedID,
      'diseaseID': diseaseID,
      'patientID': patientID,
      'doctorID': doctorID,
      'dateCreated': dateCreated.toIso8601String(),
      'dateDiagnosed': dateDiagnosed?.toIso8601String(),
      'details': details,
      'patientsComment': patientsComment,
      'doctorsComment': doctorsComment,
      'editedByDoctor': editedByDoctor,
      'prescription': prescription,
      'status': status,
    };
  }
}