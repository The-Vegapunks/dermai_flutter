import 'package:dermai/features/core/entities/appointment.dart';
import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/entities/patient.dart';
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
  @override
  void initState() {
    setState(() {
      param = widget.param;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    
    return BlocConsumer<DoctorBloc, DoctorState>(
      listener: (context, state) {
        // TODO: implement listener
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
                          Expanded(
                            child: FilledButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(
                                  MaterialPageRoute(
                                    builder: (context) => ReschedulePage(
                                      param: param,
                                      insert: false,
                                    ),
                                  ),
                                )
                                    .then((value) {
                                  setState(() {
                                    param = value as (Appointment, DiagnosedDisease, Patient, Disease);
                                  });
                                });
                              },
                              child: const Text('Reschedule'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                                textStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onError),
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
                                        appointmentID: param.$1.appointmentID,
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
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('Call'),
                        ),
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
                              Text(
                                  param.$1.comment.trim().isEmpty
                                      ? 'No additional information'
                                      : param.$1.description,
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
                              Text('Comments ',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              Text(
                                  param.$1.comment.trim().isEmpty
                                      ? 'No comments'
                                      : param.$1.comment,
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
