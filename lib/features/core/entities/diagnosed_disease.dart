class DiagnosedDisease {
  const DiagnosedDisease({
    required this.diagnosedID,
    required this.picture,
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
    required this.diagnosedDiseaseName,
  });

  final String? diagnosedID;
  final String picture;
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
  final String diagnosedDiseaseName;

  factory DiagnosedDisease.fromJson(Map<String, dynamic> json) {
    return DiagnosedDisease(
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
      patientName: json['patient']['name'],
      diseaseName: json['disease']['name'],
      diagnosedDiseaseName: json['diagnosedDiseaseName'],
    );
  }

  DiagnosedDisease copyWith({
    String? diagnosedID,
    String? picture,
    int? diseaseID,
    String? patientID,
    String? doctorID,
    DateTime? dateCreated,
    DateTime? dateDiagnosed,
    String? details,
    String? patientsComment,
    String? doctorsComment,
    bool? editedByDoctor,
    String? prescription,
    bool? status,
    String? patientName,
    String? diseaseName,
    String? diagnosedDiseaseName,
  }) {
    return DiagnosedDisease(
      diagnosedID: diagnosedID ?? this.diagnosedID,
      picture: picture ?? this.picture,
      diseaseID: diseaseID ?? this.diseaseID,
      patientID: patientID ?? this.patientID,
      doctorID: doctorID ?? this.doctorID,
      dateCreated: dateCreated ?? this.dateCreated,
      dateDiagnosed: dateDiagnosed ?? this.dateDiagnosed,
      details: details ?? this.details,
      patientsComment: patientsComment ?? this.patientsComment,
      doctorsComment: doctorsComment ?? this.doctorsComment,
      editedByDoctor: editedByDoctor ?? this.editedByDoctor,
      prescription: prescription ?? this.prescription,
      status: status ?? this.status,
      patientName: patientName ?? this.patientName,
      diseaseName: diseaseName ?? this.diseaseName,
      diagnosedDiseaseName: diagnosedDiseaseName ?? this.diagnosedDiseaseName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (diagnosedID != null) 'diagnosedID': diagnosedID,
      'picture': picture,
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
      'diagnosedDiseaseName': diagnosedDiseaseName,
    };
  }
}