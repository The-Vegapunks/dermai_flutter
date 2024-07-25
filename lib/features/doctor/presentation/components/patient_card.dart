import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/doctor/presentation/pages/case_detail_page.dart';
import 'package:flutter/material.dart';

class PatientCard extends StatefulWidget {
  const PatientCard({super.key, required this.diagnosedDisease});
  final DiagnosedDisease diagnosedDisease;

  @override
  State<PatientCard> createState() => _PatientCardState();
}

class _PatientCardState extends State<PatientCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CaseDetailPage(
              diagnosedID: widget.diagnosedDisease.diagnosedID!,
            ),
          ),
        ),
        child: Card(
          child: Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.diagnosedDisease.patientName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Row(
                  children: [
                    Text(
                      widget.diagnosedDisease.diseaseName,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '|',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(width: 8),
                    if (widget.diagnosedDisease.doctorID == null)
                      Text(
                        'Available',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    if (widget.diagnosedDisease.doctorID != null)
                      Text(
                        'Assigned',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                  ],
                ),
                if (widget.diagnosedDisease.patientsComment.isNotEmpty)
                  Text(
                    widget.diagnosedDisease.patientsComment,
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
