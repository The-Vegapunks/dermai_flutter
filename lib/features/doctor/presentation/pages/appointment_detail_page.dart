import 'package:dermai/features/core/cubits/app_user/app_user_cubit.dart';
import 'package:dermai/features/core/entities/appointment.dart';
import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/entities/doctor.dart';
import 'package:dermai/features/core/entities/patient.dart';
import 'package:dermai/features/core/presentation/call_page.dart';
import 'package:dermai/features/core/presentation/textfields.dart';
import 'package:dermai/features/doctor/presentation/bloc/doctor_bloc.dart';
import 'package:dermai/features/doctor/presentation/pages/case_detail_page.dart';
import 'package:dermai/features/doctor/presentation/pages/reschedule_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AppointmentDetailPage extends StatefulWidget {
  const AppointmentDetailPage({super.key, required this.param});
  final (Appointment, DiagnosedDisease, Patient, Disease) param;

  @override
  State<AppointmentDetailPage> createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  late (Appointment, DiagnosedDisease, Patient, Disease) param;
  bool detailEdit = false;
  String detail = '';
  String comment = '';
  bool commentEdit = false;
  late Doctor doctor;
  @override
  void initState() {
    doctor = (context.read<AppUserCubit>().state as AppUserAuthenticated)
        .user
        .doctor();
    setState(() {
      param = widget.param;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorBloc, DoctorState>(
      listener: (context, state) {
        if (state is DoctorSuccessAppointment) {
          setState(() {
            param = state.response;
          });
        }
        if (state is DoctorSuccessCallPatient) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CallPage(call: state.call),
            ),
          );
        }
        if (state is DoctorFailureAppointment) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }

        if (state is DoctorFailureCallPatient) {
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
                actions: [
                  if (param.$1.status == AppointmentStatus.pending)
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () {
                            context.read<DoctorBloc>().add(
                                DoctorUpdateAppointment(
                                    appointment: param.$1.copyWith(
                                        status: AppointmentStatus.followup),
                                    insert: false));
                          },
                          child: const Text('Mark as done'),
                        ),
                      ],
                    ),
                ],
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
                                        patient: param.$3,
                                        doctor: doctor,
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
                          if (param.$1.status == AppointmentStatus.followup)
                            Expanded(
                              child: FilledButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) => ReschedulePage(
                                        appointment: param.$1,
                                        patient: param.$3,
                                        doctor: doctor,
                                        insert: true,
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
                                child: const Text('Follow Up'),
                              ),
                            ),
                          if (param.$1.status == AppointmentStatus.pending)
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
                                  context.read<DoctorBloc>().add(
                                        DoctorCancelAppointment(
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
                      if (param.$1.status == AppointmentStatus.pending &&
                          !param.$1.isPhysical)
                        const SizedBox(height: 8),
                      if (param.$1.status == AppointmentStatus.pending &&
                          !param.$1.isPhysical)
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  context.read<DoctorBloc>().add(
                                        DoctorCallPatientEvent(
                                          appointmentID:
                                              param.$1.appointmentID!,
                                        ),
                                      );
                                },
                                child: const Text('Call'),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),
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
                              if (!detailEdit)
                                Text(
                                    param.$1.description.trim().isEmpty
                                        ? 'No additional information'
                                        : param.$1.description.trim(),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              if (detailEdit)
                                UniversalTextField(
                                  maxLines: null,
                                  initialValue: param.$1.description.trim(),
                                  labelText: 'Additional Information',
                                  onChanged: (value) {
                                    setState(() {
                                      detail = value;
                                    });
                                  },
                                ),
                              if (param.$1.status !=
                                  AppointmentStatus.completed)
                                const SizedBox(height: 8),
                              if (param.$1.status !=
                                  AppointmentStatus.completed)
                                Row(
                                  children: [
                                    Expanded(
                                        child: FilledButton(
                                      onPressed: () {
                                        setState(() {
                                          detailEdit = !detailEdit;
                                        });
                                        context.read<DoctorBloc>().add(
                                            DoctorUpdateAppointment(
                                                appointment: param.$1.copyWith(
                                                    description: detail),
                                                insert: false));
                                      },
                                      child: detailEdit
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                if (state is! DoctorLoading)
                                                  const Text(
                                                      'Save Additional Information')
                                                else
                                                  const Text(
                                                      'Saving Additional Information'),
                                                if (state is DoctorLoading)
                                                  const SizedBox(width: 8),
                                                if (state is DoctorLoading)
                                                  const SizedBox(
                                                    width: 16,
                                                    height: 16,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                                  ),
                                              ],
                                            )
                                          : const Text(
                                              "Edit Additional Information"),
                                    )),
                                  ],
                                )
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
                              if (!commentEdit)
                                Text(
                                    param.$1.comment.trim().isEmpty
                                        ? 'No comment'
                                        : param.$1.comment.trim(),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              if (commentEdit)
                                UniversalTextField(
                                  maxLines: null,
                                  initialValue: param.$1.comment.trim(),
                                  labelText: 'Comment',
                                  onChanged: (value) {
                                    setState(() {
                                      comment = value;
                                    });
                                  },
                                ),
                              if (param.$1.status !=
                                  AppointmentStatus.completed)
                                const SizedBox(height: 8),
                              if (param.$1.status !=
                                  AppointmentStatus.completed)
                                Row(
                                  children: [
                                    Expanded(
                                        child: FilledButton(
                                      onPressed: () {
                                        setState(() {
                                          commentEdit = !commentEdit;
                                        });
                                        context.read<DoctorBloc>().add(
                                            DoctorUpdateAppointment(
                                                appointment: param.$1
                                                    .copyWith(comment: comment),
                                                insert: false));
                                      },
                                      child: commentEdit
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                if (state is! DoctorLoading)
                                                  const Text('Save Comment')
                                                else
                                                  const Text('Saving Comment'),
                                                if (state is DoctorLoading)
                                                  const SizedBox(width: 8),
                                                if (state is DoctorLoading)
                                                  const SizedBox(
                                                    width: 16,
                                                    height: 16,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                                  ),
                                              ],
                                            )
                                          : const Text("Edit Comment"),
                                    )),
                                  ],
                                )
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
                child: Column(
                  children: [
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
                                    builder: (context) => CaseDetailPage(
                                      diagnosedDisease: param.$2,
                                      patient: param.$3,
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
                  ],
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
