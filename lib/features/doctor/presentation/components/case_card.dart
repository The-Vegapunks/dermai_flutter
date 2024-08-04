import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/entities/patient.dart';
import 'package:flutter/material.dart';

class CaseCard extends StatefulWidget {
  const CaseCard(
      {super.key,
      required this.diagnosedDisease,
      required this.disease,
      required this.patient,
      required this.onTap});
  final DiagnosedDisease diagnosedDisease;
  final Patient patient;
  final Disease disease;
  final Function() onTap;

  @override
  State<CaseCard> createState() => _CaseCardState();
}

class _CaseCardState extends State<CaseCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Card(
          child: Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.patient.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Row(
                  children: [
                    Text(
                      widget.diagnosedDisease.editedByDoctor
                          ? (widget
                                  .diagnosedDisease.diagnosedDiseaseName.isEmpty
                              ? widget.disease.name
                              : widget.diagnosedDisease.diagnosedDiseaseName)
                          : widget.disease.name,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '|',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(width: 8),
                    if (widget.diagnosedDisease.doctorID == null &&
                        !widget.diagnosedDisease.status)
                      Text(
                        'Available',
                        style: Theme.of(context).textTheme.labelSmall,
                        
                      ),
                    if (widget.diagnosedDisease.doctorID != null &&
                        !widget.diagnosedDisease.status)
                      Text(
                        'Currently Consulting',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    if (widget.diagnosedDisease.doctorID != null &&
                        widget.diagnosedDisease.status)
                      Text(
                        'Completed',
                        style: Theme.of(context).textTheme.labelSmall,
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
