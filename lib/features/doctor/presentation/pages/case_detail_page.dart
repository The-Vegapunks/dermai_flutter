import 'package:dermai/features/core/cubits/app_user/app_user_cubit.dart';
import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/doctor.dart';
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

class _CaseDetailPageState extends State<CaseDetailPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late DiagnosedDisease diagnosedDisease;
  late Doctor doctor;

  @override
  void initState() {
    super.initState();
    diagnosedDisease = widget.diagnosedDisease;

    doctor = (context.read<AppUserCubit>().state as AppUserAuthenticated)
        .user
        .doctor();

    _tabController = TabController(
        length: diagnosedDisease.doctorID == doctor.id ? 3 : 1, vsync: this);
    context
        .read<DoctorBloc>()
        .add(DoctorCaseDetails(diagnosedID: diagnosedDisease.diagnosedID!));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        if (state is DoctorSuccessCaseDetails) {
          setState(() {
            diagnosedDisease = state.diagnosedDisease;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              if (diagnosedDisease.doctorID == doctor.id) {

              } else {
                context.read<DoctorBloc>().add(DoctorUpdateCase(
                    diagnosedDisease: diagnosedDisease.copyWith(
                        doctorID: doctor.id)));
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
                        const PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(Icons.check),
                              SizedBox(width: 8),
                              Text('Mark as done'),
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
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
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
                    controller: _tabController,
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
                controller: _tabController,
                physics: diagnosedDisease.doctorID == doctor.id
                    ? const AlwaysScrollableScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: DetailsSection(diagnosedDisease: diagnosedDisease, doctor: doctor),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: CommentSection(diagnosedDisease: diagnosedDisease, doctor: doctor),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child:
                        PrescriptionSection(diagnosedDisease: diagnosedDisease, doctor: doctor),
                  ),
                ]),
          ),
        );
      },
    );
  }
}

class DetailsSection extends StatefulWidget {
  const DetailsSection({super.key, required this.diagnosedDisease, required this.doctor});
  final DiagnosedDisease diagnosedDisease;
  final Doctor doctor;

  @override
  State<DetailsSection> createState() => _DetailsSectionState();
}

class _DetailsSectionState extends State<DetailsSection> {
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
              Text(
                  widget.diagnosedDisease.editedByDoctor
                      ? 'Patient is diagnosed with ${widget.diagnosedDisease.diseaseName.toLowerCase()}.'
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
                    onPressed: () => {}, child: const Text('Edit AI Analysis')),
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
              Text('AI Preventive Measures',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(widget.diagnosedDisease.details),
              if (widget.diagnosedDisease.doctorID == widget.doctor.id)
                const SizedBox(
                  height: 16,
                ),
              if (widget.diagnosedDisease.doctorID == widget.doctor.id)
                FilledButton(
                    onPressed: () => {},
                    child: const Text('Edit Preventive Measures')),
            ],
          ),
        )),
        const SizedBox(height: 32),
      ],
    );
  }
}

class CommentSection extends StatefulWidget {
  const CommentSection({super.key, required this.diagnosedDisease, required this.doctor});
  final DiagnosedDisease diagnosedDisease;
  final Doctor doctor;

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  @override
  Widget build(BuildContext context) {
    return widget.diagnosedDisease.doctorsComment.isEmpty
        ? Center(
            child: FilledButton(
                onPressed: () => {}, child: const Text('Add Comment')),
          )
        : Card(
            child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Doctor\'s Comment',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(widget.diagnosedDisease.doctorsComment),
                if (widget.diagnosedDisease.doctorID == widget.doctor.id)
                  const SizedBox(
                    height: 16,
                  ),
                if (widget.diagnosedDisease.doctorID == widget.doctor.id)
                  FilledButton(
                      onPressed: () => {},
                      child: const Text('Edit my comment')),
              ],
            ),
          ));
  }
}

class PrescriptionSection extends StatefulWidget {
  const PrescriptionSection({super.key, required this.diagnosedDisease, required this.doctor});
  final DiagnosedDisease diagnosedDisease;
  final Doctor doctor;

  @override
  State<PrescriptionSection> createState() => _PrescriptionSectionState();
}

class _PrescriptionSectionState extends State<PrescriptionSection> {
  @override
  Widget build(BuildContext context) {
    return widget.diagnosedDisease.prescription.isEmpty
        ? Center(
            child: FilledButton(
                onPressed: () => {}, child: const Text('Add Prescription')),
          )
        : Card(
            child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Prescription',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(widget.diagnosedDisease.prescription),
                if (widget.diagnosedDisease.doctorID != null)
                  const SizedBox(
                    height: 16,
                  ),
                if (widget.diagnosedDisease.doctorID != null)
                  FilledButton(
                      onPressed: () => {},
                      child: const Text('Edit prescription')),
              ],
            ),
          ));
  }
}
