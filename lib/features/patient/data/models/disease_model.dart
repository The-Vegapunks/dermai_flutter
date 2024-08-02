import 'package:dermai/features/core/entities/disease.dart';

class DiseaseModel extends Disease {
  DiseaseModel({
    required super.diseaseID,
    required super.name,
    required super.description,
  });

  factory DiseaseModel.fromJson(Map<String, dynamic> json) {
    return DiseaseModel(
      diseaseID: json['diseaseID'],
      name: json['name'],
      description: json['description'] ?? '',
    );
  }
}