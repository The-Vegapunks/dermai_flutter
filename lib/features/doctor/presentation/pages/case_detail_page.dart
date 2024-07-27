import 'dart:math';

import 'package:dermai/features/core/cubits/app_user/app_user_cubit.dart';
import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/doctor.dart';
import 'package:dermai/features/core/presentation/textfields.dart';
import 'package:dermai/features/doctor/presentation/bloc/doctor_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:intl/intl.dart';

class CaseDetailPage extends StatefulWidget {
  const CaseDetailPage({super.key, required this.diagnosedDisease});

  final DiagnosedDisease diagnosedDisease;

  @override
  State<CaseDetailPage> createState() => _CaseDetailPageState();
}

class _CaseDetailPageState extends State<CaseDetailPage> {
  late DiagnosedDisease diagnosedDisease;
  late Doctor doctor;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    diagnosedDisease = widget.diagnosedDisease;

    doctor = (context.read<AppUserCubit>().state as AppUserAuthenticated)
        .user
        .doctor();
    context
        .read<DoctorBloc>()
        .add(DoctorCaseDetails(diagnosedID: diagnosedDisease.diagnosedID!));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorBloc, DoctorState>(
      listener: (context, state) {
        if (state is DoctorFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state is DoctorLoading) {
          setState(() {
            loading = true;
          });
        }
        if (state is DoctorSuccessCaseDetails) {
          setState(() {
            diagnosedDisease = state.diagnosedDisease;
            loading = false;
          });
        }
      },
      builder: (context, state) {
        return Stack(children: [
          DefaultTabController(
            length: diagnosedDisease.doctorID == doctor.id ? 3 : 1,
            child: Scaffold(
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  if (diagnosedDisease.doctorID == doctor.id) {
                  } else {
                    context.read<DoctorBloc>().add(DoctorUpdateCase(
                        diagnosedDisease:
                            diagnosedDisease.copyWith(doctorID: doctor.id)));
                  }
                },
                label: diagnosedDisease.doctorID == doctor.id
                    ? const Text('Video Call')
                    : const Text('Take Case'),
                icon: diagnosedDisease.doctorID == doctor.id
                    ? const Icon(Icons.video_call)
                    : const Icon(Icons.add),
              ),
              body: NestedScrollView(
                scrollDirection: Axis.vertical,
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    actions: [
                      if (diagnosedDisease.doctorID == doctor.id)
                        PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              onTap: () => {
                                context.read<DoctorBloc>().add(DoctorUpdateCase(
                                    diagnosedDisease: diagnosedDisease.copyWith(
                                        status: !diagnosedDisease.status,
                                        editedByDoctor: true))),
                                if (diagnosedDisease.status)
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Case reopened'),
                                      ),
                                    )
                                  }
                                else
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Case completed'),
                                      ),
                                    ),
                                    Navigator.pop(context)
                                  }
                              },
                              child: Row(
                                children: [
                                  Icon(diagnosedDisease.status
                                      ? Icons.open_in_new
                                      : Icons.check),
                                  const SizedBox(width: 8),
                                  Text(diagnosedDisease.status
                                      ? 'Reopen case'
                                      : 'Mark as completed'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today),
                                  SizedBox(width: 8),
                                  Text('Give an appointment'),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      tooltip:
                          MaterialLocalizations.of(context).backButtonTooltip,
                    ),
                    title: const Text('Case Detail'),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: diagnosedDisease.picture,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                  SliverPinnedHeader(
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: TabBar(
                        tabs: <Widget>[
                          const Tab(text: 'Details'),
                          if (diagnosedDisease.doctorID == doctor.id)
                            const Tab(text: 'Comments'),
                          if (diagnosedDisease.doctorID == doctor.id)
                            const Tab(text: 'Prescription'),
                        ],
                      ),
                    ),
                  )
                ],
                body: TabBarView(
                    physics: diagnosedDisease.doctorID == doctor.id
                        ? const AlwaysScrollableScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: DetailsSection(
                            diagnosedDisease: diagnosedDisease, doctor: doctor),
                      ),
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: CommentSection(
                            diagnosedDisease: diagnosedDisease, doctor: doctor),
                      ),
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: PrescriptionSection(
                            diagnosedDisease: diagnosedDisease, doctor: doctor),
                      ),
                    ]),
              ),
            ),
          ),
          if (loading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ]);
      },
    );
  }
}

class DetailsSection extends StatefulWidget {
  const DetailsSection(
      {super.key, required this.diagnosedDisease, required this.doctor});
  final DiagnosedDisease diagnosedDisease;
  final Doctor doctor;

  @override
  State<DetailsSection> createState() => _DetailsSectionState();
}

class _DetailsSectionState extends State<DetailsSection> {
  bool editAIAnalysis = false;
  bool editPreventiveMeasures = false;
  String aiAnalysis = '';
  String preventiveMeasures = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(widget.diagnosedDisease.patientName,
                  style: Theme.of(context).textTheme.titleLarge),
              if (editAIAnalysis)
                const SizedBox(
                  height: 16,
                ),
              if (editAIAnalysis)
                UniversalTextField(
                  initialValue: widget.diagnosedDisease.editedByDoctor
                      ? widget.diagnosedDisease.diagnosedDiseaseName
                      : widget.diagnosedDisease.diseaseName,
                  labelText: 'AI Analysis',
                  onChanged: (value) {
                    setState(() {
                      aiAnalysis = value;
                    });
                  },
                ),
              if (!editAIAnalysis)
                Text(
                    widget.diagnosedDisease.editedByDoctor
                        ? 'Patient is diagnosed with ${widget.diagnosedDisease.diagnosedDiseaseName.toLowerCase()}.'
                        : 'AI Analysis classified the disease as ${widget.diagnosedDisease.diseaseName.toLowerCase()}.',
                    style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              Text(
                  DateFormat.yMMMMEEEEd()
                      .format(widget.diagnosedDisease.dateCreated),
                  style: Theme.of(context).textTheme.bodySmall),
              if (widget.diagnosedDisease.doctorID == widget.doctor.id)
                const SizedBox(
                  height: 16,
                ),
              if (widget.diagnosedDisease.doctorID == widget.doctor.id)
                FilledButton(
                    onPressed: () => {
                          if (editAIAnalysis)
                            {
                              setState(() {
                                editAIAnalysis = false;
                              }),
                              context.read<DoctorBloc>().add(DoctorUpdateCase(
                                  diagnosedDisease: widget.diagnosedDisease
                                      .copyWith(
                                          diagnosedDiseaseName: aiAnalysis,
                                          editedByDoctor: true)))
                            }
                          else
                            {
                              setState(() {
                                editAIAnalysis = true;
                                aiAnalysis =
                                    widget.diagnosedDisease.editedByDoctor
                                        ? widget.diagnosedDisease
                                            .diagnosedDiseaseName
                                        : widget.diagnosedDisease.diseaseName;
                              })
                            }
                        },
                    child: Text(editAIAnalysis
                        ? 'Save'
                        : widget.diagnosedDisease.editedByDoctor
                            ? 'Edit analysis'
                            : 'Edit AI Analysis')),
            ],
          ),
        )),
        const SizedBox(height: 8),
        Card(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Patient\'s Comment',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(widget.diagnosedDisease.patientsComment),
            ],
          ),
        )),
        const SizedBox(height: 8),
        Card(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                  widget.diagnosedDisease.editedByDoctor
                      ? 'Preventive Measures'
                      : 'AI Preventive Measures',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (editPreventiveMeasures)
                UniversalTextField(
                  initialValue: widget.diagnosedDisease.details,
                  labelText: 'Preventive Measures',
                  onChanged: (value) {
                    setState(() {
                      preventiveMeasures = value;
                    });
                  },
                ),
              if (!editPreventiveMeasures)
                Text(widget.diagnosedDisease.details.isEmpty
                    ? 'No preventive measures given'
                    : widget.diagnosedDisease.details),
              if (widget.diagnosedDisease.doctorID == widget.doctor.id)
                const SizedBox(
                  height: 16,
                ),
              if (widget.diagnosedDisease.doctorID == widget.doctor.id)
                FilledButton(
                    onPressed: () => {
                          if (editPreventiveMeasures)
                            {
                              setState(() {
                                editPreventiveMeasures = false;
                              }),
                              context.read<DoctorBloc>().add(DoctorUpdateCase(
                                  diagnosedDisease: widget.diagnosedDisease
                                      .copyWith(
                                          details: preventiveMeasures,
                                          editedByDoctor: true)))
                            }
                          else
                            {
                              setState(() {
                                editPreventiveMeasures = true;
                                preventiveMeasures =
                                    widget.diagnosedDisease.details;
                              })
                            }
                        },
                    child: Text(editPreventiveMeasures
                        ? 'Save'
                        : 'Edit Preventive Measures')),
            ],
          ),
        )),
        const SizedBox(height: 32),
      ],
    );
  }
}

class CommentSection extends StatefulWidget {
  const CommentSection(
      {super.key, required this.diagnosedDisease, required this.doctor});
  final DiagnosedDisease diagnosedDisease;
  final Doctor doctor;

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  bool editComment = false;
  String comment = '';
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Doctor\'s Comment',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (editComment)
            UniversalTextField(
              initialValue: widget.diagnosedDisease.doctorsComment,
              labelText: 'Comment',
              onChanged: (value) {
                setState(() {
                  comment = value;
                });
              },
            ),
          if (!editComment)
            Text(widget.diagnosedDisease.doctorsComment.isEmpty
                ? 'No comments added'
                : widget.diagnosedDisease.doctorsComment),
          if (widget.diagnosedDisease.doctorID == widget.doctor.id)
            const SizedBox(
              height: 16,
            ),
          if (widget.diagnosedDisease.doctorID == widget.doctor.id)
            FilledButton(
                onPressed: () => {
                      if (editComment)
                        {
                          setState(() {
                            editComment = false;
                          }),
                          context.read<DoctorBloc>().add(DoctorUpdateCase(
                              diagnosedDisease: widget.diagnosedDisease
                                  .copyWith(
                                      doctorsComment: comment,
                                      editedByDoctor: true)))
                        }
                      else
                        {
                          setState(() {
                            editComment = true;
                            comment = widget.diagnosedDisease.doctorsComment;
                          })
                        }
                    },
                child: Text(editComment
                    ? 'Save'
                    : widget.diagnosedDisease.doctorsComment.isEmpty
                        ? 'Add Comment'
                        : 'Edit my comment')),
        ],
      ),
    ));
  }
}

class PrescriptionSection extends StatefulWidget {
  const PrescriptionSection(
      {super.key, required this.diagnosedDisease, required this.doctor});
  final DiagnosedDisease diagnosedDisease;
  final Doctor doctor;

  @override
  State<PrescriptionSection> createState() => _PrescriptionSectionState();
}

class _PrescriptionSectionState extends State<PrescriptionSection> {
  bool editPrescription = false;
  String prescription = '';
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Prescription', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (editPrescription)
            UniversalTextField(
              initialValue: widget.diagnosedDisease.prescription,
              labelText: 'Prescription',
              onChanged: (value) {
                setState(() {
                  prescription = value;
                });
              },
            ),
          if (!editPrescription)
            Text(widget.diagnosedDisease.prescription.isEmpty
                ? 'No prescription given'
                : widget.diagnosedDisease.prescription),
          if (widget.diagnosedDisease.doctorID != null)
            const SizedBox(
              height: 16,
            ),
          if (widget.diagnosedDisease.doctorID != null)
            FilledButton(
                onPressed: () => {
                      if (editPrescription)
                        {
                          setState(() {
                            editPrescription = false;
                          }),
                          context.read<DoctorBloc>().add(DoctorUpdateCase(
                              diagnosedDisease: widget.diagnosedDisease
                                  .copyWith(
                                      prescription: prescription,
                                      editedByDoctor: true)))
                        }
                      else
                        {
                          setState(() {
                            editPrescription = true;
                            prescription = widget.diagnosedDisease.prescription;
                          })
                        }
                    },
                child: Text(editPrescription
                    ? 'Save'
                    : widget.diagnosedDisease.prescription.isEmpty
                        ? 'Add Prescription'
                        : 'Edit Prescription')),
        ],
      ),
    ));
  }
}
