// import 'dart:math';

import 'package:dermai/features/doctor/presentation/pages/cases_page.dart';
import 'package:dermai/features/patient/presentation/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentDetailsPage extends StatelessWidget {
  //todo: cannot convert to stateful
  const AppointmentDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                    child: Text(param.$3.name, style: Theme.of(context).textTheme.displaySmall),
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
                          child: ElevatedButton(
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
                      if (param.$1.status == AppointmentStatus.pending)
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.error,
                              textStyle: TextStyle(color: Theme.of(context).colorScheme.onError),
                            ),
                            onPressed: () async {
                              final result = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Are you sure?'),
                                  content: const Text('This action will permanently cancel the appointment.'),
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
                          Text('Additional Information', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text(
                              param.$1.description.trim().isEmpty
                                  ? 'No additional information'
                                  : param.$1.description.trim(),
                              style: Theme.of(context).textTheme.bodyMedium),
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
                          Text('Comment', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text(
                              param.$1.comment.trim().isEmpty ? 'No comment' : param.$1.comment.trim(),
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ));
  }

  Text physicalAppt1() {
    return const Text(
      "Physical Appointment",
      textAlign: TextAlign.start,
      style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w300,
          color: Colors.white),
    );
  }

  SizedBox buttons2(BuildContext context) {
    return SizedBox(
      // color: Colors.red,
      height: 70,
      width: 420,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ChatPagePatient()));
              }, //MUST PROGRAM
              style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple[300],
                      minimumSize: const Size(150, 50))
                  .copyWith(
                      overlayColor: WidgetStatePropertyAll(
                          Colors.deepPurple[500])),
              child: const Text(
                "Reschedule",
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600),
              )),
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: BorderSide(color: Color(0xFFE53935)),
                      // backgroundColor: Colors.red[400],
                      minimumSize: const Size(150, 50))
                  .copyWith(
                      overlayColor:
                          WidgetStatePropertyAll(Colors.red[700])),
              onPressed: () {}, //MUST PROGRAM
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ))
        ],
      ),
    );
  }
}

