import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/doctor/presentation/pages/case_detail_page.dart';
import 'package:flutter/material.dart';

class CaseCard extends StatefulWidget {
  const CaseCard({super.key, required this.diagnosedDisease});
  final DiagnosedDisease diagnosedDisease;

  @override
  State<CaseCard> createState() => _CaseCardState();
}

class _CaseCardState extends State<CaseCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CaseDetailPage(
              diagnosedDisease: widget.diagnosedDisease,
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
                    if (widget.diagnosedDisease.doctorID == null && !widget.diagnosedDisease.status)
                      Text(
                        'Available',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    if (widget.diagnosedDisease.doctorID != null && !widget.diagnosedDisease.status)
                      Text(
                        'Currently Consulting',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    if (widget.diagnosedDisease.doctorID != null && widget.diagnosedDisease.status)
                      Text(
                        'Completed',
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
