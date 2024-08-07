import 'package:cached_network_image/cached_network_image.dart';
import 'package:dermai/features/auth/presentation/pages/settings_page.dart';
import 'package:dermai/features/core/cubits/app_user/app_user_cubit.dart';
import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/entities/doctor.dart';
import 'package:dermai/features/core/entities/patient.dart';
import 'package:dermai/features/patient/presentation/bloc/patient_bloc.dart';
import 'package:dermai/features/patient/presentation/pages/ai_page.dart';
import 'package:dermai/features/patient/presentation/pages/patient_case_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<(DiagnosedDisease, Disease, Doctor?)> diagnosedDiseases = [];
  late Patient patient;

  @override
  void initState() {
    patient = (context.read<AppUserCubit>().state as AppUserAuthenticated)
        .user
        .patient();
    _fetchDiagnosedDiseases();
    super.initState();
  }

  Future<void> _fetchDiagnosedDiseases() async {
    context
        .read<PatientBloc>()
        .add(PatientDiagnosedDiseases(patientID: patient.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientBloc, PatientState>(
      listener: (context, state) {
        if (state is PatientSuccessDiagnosedDiseases) {
          setState(() {
            diagnosedDiseases = state.diagnosedDiseases;
          });
        }
        if (state is PatientFailureDiagnosedDiseases) {
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
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AIPage()))
                  .then((value) {
                context
                    .read<PatientBloc>()
                    .add(PatientDiagnosedDiseases(patientID: patient.id));
              });
            },
            child: const Icon(Icons.add),
          ),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  floating: true,
                  pinned: false,
                  snap: true,
                  title: Text(
                    patient.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const SettingsPage()));
                        },
                        icon: const Icon(Icons.settings)),
                  ],
                )
              ];
            },
            body: state is PatientInitial ||
                    (state is PatientLoading && diagnosedDiseases.isEmpty)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ((state is! PatientLoading && diagnosedDiseases.isEmpty)
                    ? const Center(
                        child: Text(
                            textAlign: TextAlign.center,
                            'No diseases diagnosed yet.\nClick on the + button to diagnose a disease.'),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          await _fetchDiagnosedDiseases();
                        },
                      child: ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: diagnosedDiseases.length,
                          itemBuilder: (context, index) {
                            return DiagnosisCard(
                              diagnosedDisease: diagnosedDiseases[index],
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PatientCaseDetailPage(
                                                diagnosedDisease:
                                                    diagnosedDiseases[index].$1,
                                                disease:
                                                    diagnosedDiseases[index].$2,
                                                doctor: diagnosedDiseases[index]
                                                    .$3))).then((value) {
                                  context.read<PatientBloc>().add(
                                      PatientDiagnosedDiseases(
                                          patientID: patient.id));
                                });
                              },
                            );
                          },
                        ),
                    )),
          ),
        );
      },
    );
  }
}

class DiagnosisCard extends StatelessWidget {
  final (DiagnosedDisease, Disease, Doctor?) diagnosedDisease;
  final Function onTap;

  const DiagnosisCard(
      {super.key, required this.diagnosedDisease, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              child: CachedNetworkImage(
                imageUrl: diagnosedDisease.$1.picture,
                height: 192.0,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    diagnosedDisease.$1.diagnosedDiseaseName.isEmpty
                        ? diagnosedDisease.$2.name
                        : diagnosedDisease.$1.diagnosedDiseaseName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "${DateFormat.yMMMd().format(diagnosedDisease.$1.dateCreated)} | ${diagnosedDisease.$1.status ? 'Diagnosed' : (diagnosedDisease.$1.doctorID == null ? 'No doctor assigned yet' : 'In Progress')}",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
