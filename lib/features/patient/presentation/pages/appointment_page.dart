import 'package:flutter/material.dart';
import 'package:dermai/features/patient/presentation/pages/appointment_details_page.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

//Block to connect Date and Description box
//class to fetch and store data in the class
//call class to display data

/*class _Displaytab extends State<AppointmentPage> {
  @override
}*/

class _AppointmentPageState extends State<AppointmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date To Insert',
            style: TextStyle(
                color: Colors.white,
                fontSize: 35,
                fontWeight: FontWeight.w600)),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.deepPurple[50],
                  borderRadius: BorderRadius.circular(20)),
              height: 200,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const AppointmentDetailsPage()));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 200,
            color: Colors.deepPurple[50],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 200,
            color: Colors.deepPurple[50],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 200,
            color: Colors.deepPurple[50],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 200,
            color: Colors.deepPurple[50],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 200,
            color: Colors.deepPurple[50],
          ),
        ),
      ]),
    );
  }
}
