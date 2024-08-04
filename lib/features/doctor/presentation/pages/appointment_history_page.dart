import 'package:dermai/features/core/cubits/app_user/app_user_cubit.dart';
import 'package:dermai/features/core/entities/appointment.dart';
import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/entities/doctor.dart';
import 'package:dermai/features/core/entities/patient.dart';
import 'package:dermai/features/doctor/presentation/bloc/doctor_bloc.dart';
import 'package:dermai/features/doctor/presentation/components/appointment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

class AppointmentHistoryPage extends StatefulWidget {
  const AppointmentHistoryPage({super.key, required this.diagnosedID});
  final String diagnosedID;

  @override
  State<AppointmentHistoryPage> createState() => _AppointmentHistoryPageState();
}

class _AppointmentHistoryPageState extends State<AppointmentHistoryPage> {
  Map<DateTime, List<(Appointment, DiagnosedDisease, Patient, Disease)>>
      appointments = {};

  late final Doctor doctor;

  @override
  void initState() {
    doctor = (context.read<AppUserCubit>().state as AppUserAuthenticated)
        .user
        .doctor();
    context.read<DoctorBloc>().add(DoctorAppointments(
        doctorID: doctor.id, diagnosedID: widget.diagnosedID));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorBloc, DoctorState>(
      listener: (context, state) {
        if (state is DoctorSuccessAppointments) {
          setState(() {
            appointments = groupBy(
                state.appointments,
                (element) => DateTime(element.$1.dateCreated.year,
                    element.$1.dateCreated.month, element.$1.dateCreated.day));
          });
        }
        if (state is DoctorFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    title: const Text('Appointment History'),
                    floating: true,
                    pinned: false,
                    snap: true,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ];
              },
              body: (state is DoctorInitial ||
                      (state is DoctorLoading && appointments.isEmpty))
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ((appointments.keys.isEmpty && state is! DoctorLoading)
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
                              onTap: () {
                                context.read<DoctorBloc>().add(
                                      DoctorAppointments(
                                          doctorID: doctor.id,
                                          diagnosedID: widget.diagnosedID),
                                    );
                              },
                            );
                          },
                        )),
            ),
          ),
        );
      },
    );
  }
}
