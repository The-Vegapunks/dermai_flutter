import 'package:dermai/features/core/cubits/app_user/app_user_cubit.dart';
import 'package:dermai/features/core/entities/appointment.dart';
import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/entities/doctor.dart';
import 'package:dermai/features/core/entities/patient.dart';
import 'package:dermai/features/doctor/presentation/bloc/doctor_bloc.dart';
import 'package:dermai/features/doctor/presentation/pages/appointment_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:intl/intl.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  List<(Appointment, DiagnosedDisease, Patient, Disease)> appointments = [];
  late Doctor doctor;
  DateTime selectedDate = DateTime.now();
  //filter
  List<(Appointment, DiagnosedDisease, Patient, Disease)>
      _filteredAppointments = [];
  List<NeatCleanCalendarEvent> _events = [];

  @override
  void initState() {
    _fetchAppointments();
    super.initState();
  }

  Future<void> _fetchAppointments() async {
    doctor = (context.read<AppUserCubit>().state as AppUserAuthenticated)
        .user
        .doctor();
    context.read<DoctorBloc>().add(DoctorAppointments(doctorID: doctor.id));
  }

  void _handleAppointmentDateChange(DateTime date) {
    setState(() {
      selectedDate = date;
      _filteredAppointments = appointments
          .where((element) =>
              element.$1.dateCreated.day == date.day &&
              element.$1.dateCreated.month == date.month &&
              element.$1.dateCreated.year == date.year)
          .toList();
      _events = appointments
          .map((e) => NeatCleanCalendarEvent(
                e.$3.name,
                startTime: e.$1.dateCreated,
                endTime: e.$1.dateCreated.add(const Duration(hours: 1)),
                description: e.$1.description,
                color: Colors.blue,
              ))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorBloc, DoctorState>(
      listener: (context, state) {
        if (state is DoctorSuccessAppointments) {
          setState(() {
            appointments = state.appointments;
          });
          _handleAppointmentDateChange(selectedDate);
        }
        if (state is DoctorFailureAppointments) {
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
            child: Calendar(
              onDateSelected: _handleAppointmentDateChange,
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
                            child: Text(
                              'No appointments on this day',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          )
                        : ListView.builder(
                            itemCount: selectedEvents.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AppointmentDetailPage(
                                          param: _filteredAppointments[index],
                                        ),
                                      ),
                                    )
                                        .then((_) {
                                      _fetchAppointments();
                                    });
                                  },
                                  child: Card(
                                    child: Container(
                                      margin: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${DateFormat.Hm().format(
                                              _filteredAppointments[index]
                                                  .$1
                                                  .dateCreated,
                                            )} - ${_filteredAppointments[index].$3.name}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            '${_filteredAppointments[index].$2.diagnosedDiseaseName.isEmpty ? _filteredAppointments[index].$4.name : _filteredAppointments[index].$2.diagnosedDiseaseName} | ${_filteredAppointments[index].$1.isPhysical ? 'Physical' : 'Online'}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
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
          ),
        );
      },
    );
  }
}
