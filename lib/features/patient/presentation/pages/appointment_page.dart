import 'package:dermai/features/core/entities/appointment.dart';
import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/disease.dart';
import 'package:dermai/features/core/entities/patient.dart';
import 'package:flutter/material.dart';
import 'package:dermai/features/patient/presentation/pages/appointment_details_page.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        elevation: 0,
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          Text(
            'Monday, 8 Jul',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          CardExample(
            doctorName: 'Dr. Stone',
            time: '10:00',
            description:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis',
          ),
          SizedBox(height: 16),
          Text(
            'Tuesday, 9 Jul',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          CardExample(
            doctorName: 'Dr. Stone',
            time: '10:00',
            description:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis',
          ),
          SizedBox(height: 8),
          CardExample(
            doctorName: 'Dr. Doe',
            time: '13:00',
            description:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis',
          ),
        ],
      ),
    );
  }
}

class CardExample extends StatelessWidget {
  final String doctorName;
  final String time;
  final String description;

  const CardExample({
    super.key,
    required this.doctorName,
    required this.time,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppointmentDetailPage(param: (
                    Appointment(
                        comment: "",
                        diagnosedID: "",
                        description: "",
                        isPhysical: false,
                        appointmentID: "",
                        status: AppointmentStatus.pending,
                        dateCreated: DateTime.now()),
                    DiagnosedDisease(
                        diagnosedID: "",
                        picture: "",
                        diseaseID: 1,
                        patientID: "",
                        doctorID: "",
                        dateCreated: DateTime.now(),
                        dateDiagnosed: DateTime.now(),
                        details: "",
                        patientsComment: "",
                        doctorsComment: "",
                        editedByDoctor: false,
                        prescription: "",
                        status: false,
                        diagnosedDiseaseName: ""),
                    Patient(id: "", name: "", email: ""),
                    const Disease(diseaseID: 1, name: "", description: "")
                  )),
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctorName,
                  style: const TextStyle(
                    // fontSize: 18,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '"$description"',
                  // style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    time,
                    style: const TextStyle(
                      // fontSize: 16,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
