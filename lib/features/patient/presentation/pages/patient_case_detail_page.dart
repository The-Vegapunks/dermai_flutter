import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/entities/patient.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:intl/intl.dart';

class PatientCaseDetailPage extends StatefulWidget {
  const PatientCaseDetailPage(
      {super.key});


  @override
  State<PatientCaseDetailPage> createState() => _PatientCaseDetailPageState();
}

class _PatientCaseDetailPageState extends State<PatientCaseDetailPage> {
  DiagnosedDisease diagnosedDisease = DiagnosedDisease(diagnosedID:"mfkevmv", picture: "skmddcmldwv", diseaseID: 1234, patientID: "123440", doctorID: "jnwkdnmkc", dateCreated: DateTime.now(), dateDiagnosed: DateTime.now(), details: "fkoefrif", patientsComment: "dkmwdemfomwovmw", doctorsComment: "fkmedkffwvk", editedByDoctor: true, prescription: "dnhycfwnvjfnv", status: true, diagnosedDiseaseName:"uejkffkmrwv");


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            scrollDirection: Axis.vertical,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                ),
                title: const Text('Case Detail'),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: diagnosedDisease.picture,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              SliverPinnedHeader(
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: TabBar(
                    tabs: const <Widget>[
                      Tab(text: 'Details'),
                      Tab(text: 'Comments'),
                      Tab(text: 'Prescription'),
                    ],
                  ),
                ),
              )
            ],
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: DetailsSection(
                    diagnosedDisease: diagnosedDisease,
                    patient: Patient(email: "effjfsofsnosdv", id: "1243", name: "mfeqofrvom"),
                    disease: Disease(description: "djcndqc" , diseaseID: 1234 ,name: "fnkefor" ),
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: CommentSection(diagnosedDisease: diagnosedDisease),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: PrescriptionSection(diagnosedDisease: diagnosedDisease),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DetailsSection extends StatelessWidget {
  const DetailsSection(
      {super.key,
      required this.diagnosedDisease,
      required this.patient,
      required this.disease});

  final DiagnosedDisease diagnosedDisease;
  final Patient patient;
  final Disease disease;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  patient.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  diagnosedDisease.editedByDoctor
                      ? 'Patient is diagnosed with ${diagnosedDisease.diagnosedDiseaseName.toLowerCase()}.'
                      : 'AI Analysis classified the disease as ${disease.name.toLowerCase()}.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  DateFormat.yMMMMEEEEd().format(diagnosedDisease.dateCreated),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Patient\'s Comment',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(diagnosedDisease.patientsComment),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  diagnosedDisease.editedByDoctor
                      ? 'Preventive Measures'
                      : 'AI Preventive Measures',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(diagnosedDisease.details.isEmpty
                    ? 'No preventive measures given'
                    : diagnosedDisease.details),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class CommentSection extends StatelessWidget {
  const CommentSection({super.key, required this.diagnosedDisease});

  final DiagnosedDisease diagnosedDisease;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Doctor\'s Comment',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(diagnosedDisease.doctorsComment.isEmpty
                    ? 'No comments added'
                    : diagnosedDisease.doctorsComment),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class PrescriptionSection extends StatelessWidget {
  const PrescriptionSection({super.key, required this.diagnosedDisease});

  final DiagnosedDisease diagnosedDisease;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Prescription',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(diagnosedDisease.prescription.isEmpty
                    ? 'No prescription given'
                    : diagnosedDisease.prescription),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}