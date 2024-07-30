import 'package:dermai/features/auth/presentation/pages/welcome_page.dart';
import 'package:dermai/features/core/cubits/app_user/app_user_cubit.dart';
import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/entities/doctor.dart';
import 'package:dermai/features/core/entities/patient.dart';
import 'package:dermai/features/patient/presentation/bloc/patient_bloc.dart';
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
  bool isLoading = false;

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
            isLoading = false;
          });
        }
        if (state is PatientFailure) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
        if (state is PatientLoading) {
          setState(() {
            isLoading = true;
          });
        }
        if (state is PatientSuccessSignOut) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You have been signed out'),
            ),
          );
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const WelcomePage()));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  title: const Text('Welcome back'),
                  actions: [
                    IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Signing out...'),
                            ),
                          );
                          context.read<PatientBloc>().add(PatientSignOut());
                        },
                        icon: const Icon(Icons.logout)),
                  ],
                )
              ];
            },
            body: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: diagnosedDiseases.length,
                    itemBuilder: (context, index) {
                      return DiagnosisCard(
                        diagnosedDisease: diagnosedDiseases[index],
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}

class DiagnosisCard extends StatelessWidget {
  final (DiagnosedDisease, Disease, Doctor?) diagnosedDisease;

  const DiagnosisCard({super.key, required this.diagnosedDisease});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PatientCaseDetailPage(
                    diagnosedDisease: diagnosedDisease.$1,
                    disease: diagnosedDisease.$2,
                    doctor: diagnosedDisease.$3)));
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
              child: Image.network(
                diagnosedDisease.$1.picture,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 192.0,
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
