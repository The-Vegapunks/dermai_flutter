import 'package:dermai/features/patient/presentation/bloc/patient_bloc.dart';
import 'package:dermai/features/patient/presentation/pages/patient_case_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientBloc, PatientState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Welcome Back'),
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  // Handle logout action
                },
              ),
            ],
          ),
          body: ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              DiagnosisCard(
                imageUrl:
                    'assets/dermatitis.png', // Replace with your image asset path
                diagnosis: 'Dermatitis',
                date: '05/07/2024',
              ),
              DiagnosisCard(
                imageUrl:
                    'assets/tinea.png', // Replace with your image asset path
                diagnosis: 'Tinea',
                date: '01/06/2024',
              ),
              DiagnosisCard(
                imageUrl:
                    'assets/another_diagnosis.png', // Replace with your image asset path
                diagnosis: 'Ringworm',
                date: '01/05/2024',
              ),
            ],
          ),
        );
      },
    );
  }
}

class DiagnosisCard extends StatelessWidget {
  final String imageUrl;
  final String diagnosis;
  final String date;

  DiagnosisCard(
      {required this.imageUrl, required this.diagnosis, required this.date});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PatientCaseDetailPage()));
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 150.0,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    diagnosis,
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    date,
                    style: TextStyle(color: Colors.grey[600]),
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
