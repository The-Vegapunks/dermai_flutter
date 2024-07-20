import 'package:dermai/features/patient/presentation/pages/ai_page.dart';
import 'package:dermai/features/patient/presentation/pages/appointment_page.dart';
import 'package:dermai/features/patient/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPageIndex = 0;
  final List<Widget> _screens = [
    const HomePage(),
    const AppointmentPage(),
    const AiPage(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget> [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            label: 'Appointment',
          ),
          NavigationDestination(
            icon: Icon(Icons.medical_services),
            label: 'AI',
          ),
        ]
      )
    );
  }
}