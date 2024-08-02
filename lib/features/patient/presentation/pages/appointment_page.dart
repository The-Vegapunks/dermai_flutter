import 'package:dermai/features/core/cubits/app_user/app_user_cubit.dart';
import 'package:dermai/features/core/entities/appointment.dart';
import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/entities/doctor.dart';
import 'package:dermai/features/core/entities/patient.dart';
import 'package:dermai/features/patient/presentation/bloc/patient_bloc.dart';
import 'package:dermai/features/patient/presentation/components/appointment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                const SliverAppBar(
                  floating: true,
                  pinned: false,
                  snap: true,
                  title: Text('Appointment'),
                )
              ];
            },
            body: appointments.keys.isEmpty
                ? const Center(
                    child: Text('No Appointments'),
                  )
                : ListView.builder(
                    itemCount: appointments.keys.length,
                    itemBuilder: (context, index) {
                      DateTime key = appointments.keys.elementAt(index);
                      return AppointmentCard(
                        date: key,
                        appointments: appointments[key]!,
                        patient: patient,
                        onTap: () {
                          context.read<PatientBloc>().add(
                                PatientAppointments(patientID: patient.id),
                              );
                        },
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
