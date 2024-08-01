import 'package:dermai/features/core/cubits/app_user/app_user_cubit.dart';
import 'package:dermai/features/core/entities/appointment.dart';
import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/entities/doctor.dart';
import 'package:dermai/features/core/entities/patient.dart';
import 'package:dermai/features/patient/presentation/bloc/patient_bloc.dart';
import 'package:dermai/features/patient/presentation/pages/appointment_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  Map<DateTime, List<(Appointment, DiagnosedDisease, Doctor, Disease)>>
      appointments = {};
  late Patient patient;

  @override
  void initState() {
    patient = (context.read<AppUserCubit>().state as AppUserAuthenticated)
        .user
        .patient();
    context.read<PatientBloc>().add(
          PatientAppointments(patientID: patient.id),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientBloc, PatientState>(
      listener: (context, state) {
        if (state is PatientFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
        if (state is PatientSuccessAppointments) {
          setState(() {
            appointments = state.appointments;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: ListView.builder(
            itemCount: appointments.keys.length,
            itemBuilder: (context, index) {
              DateTime key = appointments.keys.elementAt(index);
              return CardExample(date: key, appointments: appointments[key]!, patient: patient);
            },
          ),
        );
      },
    );
  }
}

class CardExample extends StatefulWidget {
  final List<(Appointment, DiagnosedDisease, Doctor, Disease)> appointments;
  final DateTime date;
  final Patient patient;
  const CardExample(
      {super.key, required this.date, required this.appointments, required this.patient});

  @override
  State<CardExample> createState() => _CardExampleState();
}

class _CardExampleState extends State<CardExample> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            DateFormat.yMMMMd().format(widget.date),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shrinkWrap: true,
          itemCount: widget.appointments.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppointmentDetailPage(
                        param: widget.appointments[index]),
                  ),
                ).then((_) {
                  context.read<PatientBloc>().add(
                        PatientAppointments(patientID: widget.patient.id),
                      );
                });
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.appointments[index].$3.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.appointments[index].$1.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          DateFormat.Hm().format(
                              widget.appointments[index].$1.dateCreated),
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
    // Center(
    //   child: GestureDetector(
    //     onTap: () {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => AppointmentDetailPage(param: appointment),
    //         ),
    //       );
    //     },
    //     child: Card(
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(16.0),
    //       ),
    //       child: Padding(
    //         padding: const EdgeInsets.all(16.0),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(appointment.$3.name),
    //             const SizedBox(height: 8),
    //             Text(
    //               appointment.$1.description,
    //               maxLines: 3,
    //               overflow: TextOverflow.ellipsis,
    //             ),
    //             const SizedBox(height: 16),
    //             Align(
    //               alignment: Alignment.bottomRight,
    //               child: Text(
    //                 DateFormat.Hm().format(appointment.$1.dateCreated),
    //                 style: const TextStyle(
    //                   color: Colors.grey,
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
