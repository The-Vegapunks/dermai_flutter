import 'package:dermai/features/core/cubits/app_user/app_user_cubit.dart';
import 'package:dermai/features/core/entities/appointment.dart';
import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/entities/doctor.dart';
import 'package:dermai/features/core/entities/patient.dart';
import 'package:dermai/features/core/presentation/call_page.dart';
import 'package:dermai/features/doctor/presentation/pages/reschedule_page.dart';
import 'package:dermai/features/patient/presentation/bloc/patient_bloc.dart';
import 'package:dermai/features/patient/presentation/pages/patient_case_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AppointmentDetailPage extends StatefulWidget {
  const AppointmentDetailPage({super.key, required this.param});
  final (Appointment, DiagnosedDisease, Doctor, Disease) param;

  @override
  State<AppointmentDetailPage> createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  late (Appointment, DiagnosedDisease, Doctor, Disease) param;
  late Patient patient;

  @override
  void initState() {
    patient = (context.read<AppUserCubit>().state as AppUserAuthenticated)
        .user
        .patient();
    setState(() {
      param = widget.param;
    });
    context
        .read<PatientBloc>()
        .add(PatientConnectStreamEvent(id: patient.id, name: patient.name));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientBloc, PatientState>(
      listener: (context, state) {
        if (state is PatientSuccessCallDoctor) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CallPage(call: state.call),
            ),
          );
        }
        if (state is PatientFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(slivers: [
              SliverAppBar(
                pinned: true,
                title: const Text('Appointment Detail'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      Align(
                        alignment: Alignment.center,
                        child: Text(param.$3.name,
                            style: Theme.of(context).textTheme.displaySmall),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                            '${DateFormat.yMd().format(param.$1.dateCreated)} - ${DateFormat.Hm().format(param.$1.dateCreated)}',
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                      const SizedBox(width: 8),
                      Align(
                        child: Text(
                            param.$1.isPhysical
                                ? 'Physical Appointment for ${param.$2.diagnosedDiseaseName.isEmpty ? param.$4.name : param.$2.diagnosedDiseaseName}'
                                : 'Online Appointment for ${param.$2.diagnosedDiseaseName.isEmpty ? param.$4.name : param.$2.diagnosedDiseaseName}',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          if (param.$1.status == AppointmentStatus.pending)
                            Expanded(
                              child: FilledButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) => ReschedulePage(
                                        appointment: param.$1,
                                        patient: patient,
                                        doctor: param.$3,
                                        insert: false,
                                      ),
                                    ),
                                  )
                                      .then((value) {
                                    setState(() {
                                      var res = value as (
                                        Appointment,
                                        DiagnosedDisease,
                                        Disease
                                      );
                                      param =
                                          (res.$1, res.$2, param.$3, res.$3);
                                    });
                                  });
                                },
                                child: const Text('Reschedule'),
                              ),
                            ),
                          const SizedBox(width: 8),
                          if (param.$1.status == AppointmentStatus.pending)
                            Expanded(
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.error,
                                ),
                                onPressed: () async {
                                  final result = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Are you sure?'),
                                      content: const Text(
                                          'This action will permanently cancel the appointment.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: const Text('No'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                          child: const Text('Yes'),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (result == null || !result || !mounted) {
                                    return;
                                  }
                                  // ignore: use_build_context_synchronously
                                  context.read<PatientBloc>().add(
                                        PatientCancelAppointmentEvent(
                                          appointmentID:
                                              param.$1.appointmentID!,
                                        ),
                                      );
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                            ),
                        ],
                      ),
                      if (param.$1.status == AppointmentStatus.pending && !param.$1.isPhysical)
                        const SizedBox(height: 8),
                      const SizedBox(height: 8),
                      if (param.$1.status == AppointmentStatus.pending && !param.$1.isPhysical)
                        const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<PatientBloc>().add(
                                    PatientCallDoctorEvent(
                                        appointmentID:
                                            param.$1.appointmentID!));
                              },
                              child: const Text('Call'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (param.$1.isPhysical)
                        Card(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Address',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                const SizedBox(height: 8),
                                Text(
                                    param.$3.address.trim().isEmpty
                                        ? 'Address not provided'
                                        : param.$3.address.trim(),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          ),
                        ),
                      if (param.$1.isPhysical) const SizedBox(height: 8),
                      Card(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Additional Information',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              Text(
                                  param.$1.description.trim().isEmpty
                                      ? 'No additional information'
                                      : param.$1.description.trim(),
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Comment',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              Text(
                                  param.$1.comment.trim().isEmpty
                                      ? 'No comment'
                                      : param.$1.comment.trim(),
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(children: [
                  const Expanded(child: SizedBox(height: 16)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PatientCaseDetailPage(
                                    diagnosedDisease: param.$2,
                                    doctor: param.$3,
                                    disease: param.$4,
                                  ),
                                ),
                              );
                            },
                            child: const Text('View Case Details'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ]),
              ),
            ]),
          ),
        );
      },
    );
  }
}
