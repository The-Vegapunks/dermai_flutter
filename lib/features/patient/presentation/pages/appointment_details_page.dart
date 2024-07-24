import 'package:flutter/material.dart';

class AppointmentDetailsPage extends StatelessWidget {
  const AppointmentDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: detailsSection(),
    );
  }

  Column detailsSection() {
    return Column(
      children: [
        Container(
          color: Colors.yellow,
          height: 200,
          width: 420,
          child: Center(
            child: Text(
              "Dr Stone Wood",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.w400),
            ),
          ),
        )
      ],
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text('Appointment Details',
          style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w500)),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: BackButton(context),
      actions: [Dots()],
    );
  }

  GestureDetector Dots() {
    return GestureDetector(
        onTap: () {},
        child: Container(
            margin: EdgeInsets.only(right: 15),
            // decoration: BoxDecoration(
            //     color: Color(0xffF7F8F8),
            //     borderRadius: BorderRadius.circular(10)),
            // width: 37,
            // alignment: Alignment.center,
            child: Icon(
              Icons.more_vert,
              size: 20,
              color: Colors.black,
            )));
  }

  GestureDetector BackButton(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            // decoration: BoxDecoration(
            //     color: Color(0xffF7F8F8),
            //     borderRadius: BorderRadius.circular(10)),
            child: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            )));
  }
}
