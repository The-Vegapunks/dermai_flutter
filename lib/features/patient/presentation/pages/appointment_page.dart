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
//call card to display data
//number of cases for that date (to be fetched)

class _AppointmentPageState extends State<AppointmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Date To Insert',
            style: TextStyle(
                color: Colors.white,
                fontSize: 35,
                fontWeight: FontWeight.w600)),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
      ),
      body: ListView(children: [
        const CardExample(),
        const CardExample(),
      ]),
    );
  }
}

class CardExample extends StatelessWidget {
  const CardExample({super.key});

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
                        const Disease(
                            diseaseID: 1, name: "", description: "")
                      ))));
        },
        child: const Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Doctor Name'),
                subtitle: Column(
                  children: [
                    Text('Oh I am really sick'),
                    Text(''),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
