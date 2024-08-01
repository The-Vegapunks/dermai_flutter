// import 'dart:math';

// import 'package:dermai/features/doctor/presentation/pages/cases_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:fpdart/fpdart.dart';

// class AppointmentDetailsPage extends StatelessWidget {
//   const AppointmentDetailsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appBar(context),
//       body: detailsSection(context),
//     );
//   }

//   Column detailsSection(BuildContext context) {
//     return Column(
//       children: [
//         docName(),
//         buttons2(context),
//         detailsAppt(context),
//         const SizedBox(
//           width: 420,
//           height: 50,
//         ),
//         callButton(context)
//       ],
//     );
//   }

//   Container callButton(BuildContext context) {
//     return Container(
//       width: 300,
//       height: 50,
//       // color: Colors.yellow,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 backgroundColor: Colors.deepPurple[200],
//                 minimumSize: const Size(150, 50))
//             .copyWith(
//                 overlayColor:
//                     WidgetStatePropertyAll(Colors.deepPurple[400])),
//         onPressed: () {},
//         child: Text(
//           "Call",
//           style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//         ),
//       ),
//     );
//   }

//   Container detailsAppt(BuildContext context) {
//     return Container(
//       width: 365,
//       height: 415,
//       // color: Colors.red,
//       // margin: EdgeInsets.only(left: 10, right: 10),
//       padding: const EdgeInsets.only(top: 10),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           physicalAppt1(),
//           physicalAppt2(),
//           addInfo1(),
//           addInfo2(context),
//         ],
//       ),
//     );
//   }

//   Center addInfo2(BuildContext context) {
//     return Center(
//       child: Container(
//           alignment: Alignment.center,
//           width: 360,
//           height: 240,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),

//               boxShadow: [
//                 BoxShadow(
//                     color: Colors.black.withOpacity(0.3),
//                     spreadRadius: 3,
//                     blurRadius: 9,
//                     offset: const Offset(0, 4),
//                     blurStyle: BlurStyle.normal)
//               ]),
//           child: const Padding(
//             padding: EdgeInsets.only(
//                 top: 13, bottom: 15, left: 15, right: 15),
//             child: Align(
//               alignment: Alignment.topLeft,
//               child: SingleChildScrollView(
//                 child: Text(
//                     //To retrieve details from DB
//                     "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
//                     style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w400),
//                     textAlign: TextAlign.justify),
//               ),
//             ),
//           )),
//     );
//   }

//   Padding addInfo1() {
//     return const Padding(
//       padding: EdgeInsets.only(top: 20.0, bottom: 20),
//       child: Text(
//         "Additional Information",
//         style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.w300),
//       ),
//     );
//   }

//   Padding physicalAppt2() {
//     return Padding(
//         padding: const EdgeInsets.only(top: 20),
//         child: Align(
//           child: Container(
//             alignment: Alignment.center,
//             width: 360,
//             height: 45,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 boxShadow: [
//                   BoxShadow(
//                       color: Colors.black.withOpacity(0.3),
//                       spreadRadius: 3,
//                       blurRadius: 9,
//                       offset: const Offset(0, 4),
//                       blurStyle: BlurStyle.normal)
//                 ]),
//             child: const Padding(
//               padding: EdgeInsets.only(left: 15.0, right: 15),
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Text(
//                   "Desforges Medical Cabin 2nd Street DJASJDKLJASLDKLASJKLDLKJ", //To retrieve details from DB
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 17),
//                 ),
//               ),
//             ),
//           ),
//         ));
//   }

//   Text physicalAppt1() {
//     return const Text(
//       "Physical Appointment",
//       textAlign: TextAlign.start,
//       style: TextStyle(
//           fontSize: 22,
//           fontWeight: FontWeight.w300),
//     );
//   }

//   SizedBox buttons2(BuildContext context) {
//     return SizedBox(
//       // color: Colors.red,
//       height: 70,
//       width: 420,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           ElevatedButton(
//               onPressed: () {}, //MUST PROGRAM
//               style: ElevatedButton.styleFrom(
//                       foregroundColor: Colors.white,
//                       minimumSize: const Size(150, 50))
//                   .copyWith(
//                       overlayColor: WidgetStatePropertyAll(
//                           Colors.deepPurple[500])),
//               child: const Text(
//                 "Reschedule",
//                 style: TextStyle(
//                     fontSize: 15, fontWeight: FontWeight.w600),
//               )),
//           OutlinedButton(
//               style: OutlinedButton.styleFrom(
//                       foregroundColor: Colors.red,
//                       side: BorderSide(color: Color(0xFFE53935)),
//                       // backgroundColor: Colors.red[400],
//                       minimumSize: const Size(150, 50))
//                   .copyWith(
//                       overlayColor:
//                           WidgetStatePropertyAll(Colors.red[700])),
//               onPressed: () {}, //MUST PROGRAM
//               child: const Text(
//                 "Cancel",
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ))
//         ],
//       ),
//     );
//   }

//   SizedBox docName() {
//     return const SizedBox(
//       // color: Colors.yellow,
//       height: 150,
//       width: 420,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             "Dr. Stone Wood", //To retrieve details from DB
//             style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 50,
//                 fontWeight: FontWeight.w400),
//           ),
//           Text(
//             "8/07/2024 - 10:00 AM", //To retrieve details from DB
//             style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontWeight: FontWeight.w400),
//           ),
//         ],
//       ),
//     );
//   }

//   AppBar appBar(BuildContext context) {
//     return AppBar(
//       title: const Text('Appointment Details',
//           style: TextStyle(
//               color: Colors.white,
//               fontSize: 22,
//               fontWeight: FontWeight.w500)),
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       elevation: 0,
//       centerTitle: true,
//       leading: backButton(context),
//       actions: [dots(context)],
//     );
//   }

//   GestureDetector dots(BuildContext context) {
//     return GestureDetector(
//         onTap: () {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => const CasesPage()));
//         },
//         child: Container(
//             margin: const EdgeInsets.only(right: 15),
//             // decoration: BoxDecoration(
//             //     color: Color(0xffF7F8F8),
//             //     borderRadius: BorderRadius.circular(10)),
//             // width: 37,
//             // alignment: Alignment.center,
//             child: const Icon(
//               Icons.more_vert,
//               size: 20,
//               color: Colors.white,
//             )));
//   }

//   GestureDetector backButton(BuildContext context) {
//     return GestureDetector(
//         onTap: () {
//           Navigator.pop(context);
//         },
//         child: Container(
//             margin: const EdgeInsets.all(10),
//             padding: const EdgeInsets.all(10),
//             // decoration: BoxDecoration(
//             //     color: Color(0xffF7F8F8),
//             //     borderRadius: BorderRadius.circular(10)),
//             child: const Icon(
//               Icons.arrow_back_ios,
//               size: 20,
//             )));
//   }
// }
import 'package:dermai/features/core/entities/appointment.dart';
import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/entities/patient.dart';
import 'package:dermai/features/core/presentation/textfields.dart';
import 'package:dermai/features/patient/presentation/bloc/patient_bloc.dart';
import 'package:dermai/features/patient/presentation/pages/patient_case_detail_page.dart';
import 'package:dermai/features/doctor/presentation/pages/reschedule_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentDetailPage extends StatefulWidget {
  const AppointmentDetailPage({super.key, required this.param});
  final (Appointment, DiagnosedDisease, Patient, Disease) param;

  @override
  State<AppointmentDetailPage> createState() =>
      _AppointmentDetailPageState();
}

class _AppointmentDetailPageState
    extends State<AppointmentDetailPage> {
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
                        style:
                            Theme.of(context).textTheme.displaySmall),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                        '${DateFormat.yMd().format(param.$1.dateCreated)} - ${DateFormat.Hm().format(param.$1.dateCreated)}',
                        style:
                            Theme.of(context).textTheme.titleMedium),
                  ),
                  const SizedBox(width: 8),
                  Align(
                    child: Text(
                        param.$1.isPhysical
                            ? 'Physical Appointment for ${param.$2.diagnosedDiseaseName.isEmpty ? param.$4.name : param.$2.diagnosedDiseaseName}'
                            : 'Online Appointment for ${param.$2.diagnosedDiseaseName.isEmpty ? param.$4.name : param.$2.diagnosedDiseaseName}',
                        style:
                            Theme.of(context).textTheme.bodyMedium),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      if (param.$1.status ==
                          AppointmentStatus.pending)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ReschedulePage(
                                    param: param,
                                    insert: false,
                                  ),
                                ),
                              )
                                  .then((value) {
                                setState(() {
                                  param = value as (
                                    Appointment,
                                    DiagnosedDisease,
                                    Patient,
                                    Disease
                                  );
                                });
                              });
                            },
                            child: const Text('Reschedule'),
                          ),
                        ),
                      const SizedBox(width: 8),
                      if (param.$1.status ==
                          AppointmentStatus.pending)
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                              textStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onError),
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

                              if (result == null ||
                                  !result ||
                                  !mounted) {
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
                          Text('Additional Information',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium),
                          const SizedBox(height: 8),
                          Text(
                              param.$1.description.trim().isEmpty
                                  ? 'No additional information'
                                  : param.$1.description.trim(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium),
                          const SizedBox(height: 8),
                          Text(
                              param.$1.comment.trim().isEmpty
                                  ? 'No comment'
                                  : param.$1.comment.trim(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
