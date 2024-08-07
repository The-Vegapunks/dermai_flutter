import 'package:dermai/features/core/entities/appointment.dart';
import 'package:dermai/features/core/entities/doctor.dart';
import 'package:dermai/features/core/entities/patient.dart';
import 'package:dermai/features/doctor/presentation/bloc/doctor_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:intl/intl.dart';

class ReschedulePage extends StatefulWidget {
  const ReschedulePage(
      {super.key,
      required this.insert,
      required this.appointment,
      required this.patient,
      required this.doctor});
  final Appointment appointment;
  final Patient patient;
  final Doctor doctor;
  final bool insert;

  @override
  State<ReschedulePage> createState() => _ReschedulePageState();
}

class _ReschedulePageState extends State<ReschedulePage> {
  List<NeatCleanCalendarEvent> _events = [];
  late Appointment appointment;
  late Patient patient;
  late Doctor doctor;
  late bool insert;

  @override
  void initState() {
    appointment = widget.appointment;
    patient = widget.patient;
    doctor = widget.doctor;
    insert = widget.insert;
    context.read<DoctorBloc>().add(
        DoctorAvailableSlot(doctorID: doctor.id, patientID: widget.patient.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorBloc, DoctorState>(
      listener: (context, state) {
        if (state is DoctorSuccessAvailableSlot) {
          setState(() {
            _events = state.availableSlots;
          });
        }
        if (state is DoctorSuccessAppointment) {
          Navigator.pop(context,
              (state.response.$1, state.response.$2, state.response.$4));
        }
        if (state is DoctorFailureAppointment) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ));
        }
        if (state is DoctorFailureAvailableSlot) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ));
        }
      },
      builder: (context, state) {
        return Scaffold(
            body: SafeArea(
                child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                title: const Text('Available Slot'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ];
          },
          body: Calendar(
            initialDate: DateTime.now().add(const Duration(days: 1)),
            startOnMonday: true,
            weekDays: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
            eventsList: _events,
            isExpandable: true,
            eventColor: null,
            isExpanded: true,
            expandableDateFormat: 'EEEE, dd. MMMM yyyy',
            datePickerType: DatePickerType.hidden,
            selectedColor: Theme.of(context).colorScheme.primary,
            selectedTodayColor: Theme.of(context).colorScheme.secondary,
            defaultDayColor: Theme.of(context).colorScheme.onSurface,
            todayColor: Theme.of(context).colorScheme.primary,
            bottomBarColor: Theme.of(context).colorScheme.surfaceContainer,
            bottomBarArrowColor: Theme.of(context).colorScheme.onSurface,
            eventListBuilder: (BuildContext context,
                List<NeatCleanCalendarEvent> selectedEvents) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: selectedEvents.isEmpty
                      ? Center(
                          child: state is DoctorLoading
                              ? const CircularProgressIndicator()
                              : Text(
                                  'No available slot for this date',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                        )
                      : ListView.builder(
                          itemCount: selectedEvents.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: GestureDetector(
                                onTap: () async {
                                  if (widget.insert) {
                                    final result = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title:
                                            const Text('Schedule Appointment'),
                                        content: Text(
                                            'Confirm the schedule for this appointment to ${DateFormat.yMd().format(selectedEvents[index].startTime)} - ${DateFormat.Hm().format(selectedEvents[index].startTime)}.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, false);
                                            },
                                            child: const Text('No'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
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

                                    final resultSheet =
                                        await showModalBottomSheet<bool>(
                                      // ignore: use_build_context_synchronously
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                          height: 128,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () => Navigator.pop(
                                                      context, true),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text(
                                                        'Physical Appointment'),
                                                  ),
                                                ),
                                                const Divider(),
                                                GestureDetector(
                                                  onTap: () => Navigator.pop(
                                                      context, false),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text(
                                                        'Online Appointment'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );

                                    if (resultSheet == null || !mounted) {
                                      return;
                                    }
                                    // ignore: use_build_context_synchronously
                                    context
                                        .read<DoctorBloc>()
                                        .add(DoctorUpdateAppointment(
                                            appointment: appointment.copyWith(
                                              dateCreated: selectedEvents[index]
                                                  .startTime,
                                              isPhysical: resultSheet,
                                              status: AppointmentStatus.pending,
                                              comment: '',
                                              description: '',
                                            ),
                                            insert: true));
                                  } else {
                                    final result = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text(
                                            'Reschedule Appointment'),
                                        content: Text(
                                            'Confirm to reschedule this appointment to ${DateFormat.yMd().format(selectedEvents[index].startTime)} - ${DateFormat.Hm().format(selectedEvents[index].startTime)}.'),
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
                                    context
                                        .read<DoctorBloc>()
                                        .add(DoctorUpdateAppointment(
                                            appointment: appointment.copyWith(
                                              dateCreated: selectedEvents[index]
                                                  .startTime,
                                            ),
                                            insert: false));
                                  }
                                },
                                child: Card(
                                  child: Container(
                                    margin: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateFormat('hh:mm a').format(
                                              selectedEvents[index].startTime),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              );
            },
          ),
        )));
      },
    );
  }
}
