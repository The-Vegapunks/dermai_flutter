import 'package:dermai/features/auth/presentation/pages/welcome_page.dart';
import 'package:dermai/features/patient/presentation/bloc/patient_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Sign out'),
                      content: const Text('Are you sure you want to sign out?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<PatientBloc>().add(PatientSignOut());
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const WelcomePage()));
                          },
                          child: const Text('Sign out'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const Padding(
              //   padding: EdgeInsets.symmetric(vertical: 32.0),
              //   child: Center(
              //     child: Image(
              //       image: SvgPicture.asset('assets/Logo/DermAI-darkmode.svg'), // Add your logo asset path here
              //       width: 200,
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 32),
              // const Expanded(child: SizedBox(height: 128)),
              // if (isDarkMode)
              //   SvgPicture.asset("assets/Logo/DermAI-darkmode.svg")
              // else
              //   SvgPicture.asset("assets/Logo/DermAI-lightmode.svg"),
              // const SizedBox(height: 16),
              // const Expanded(child: SizedBox(height: 16)),

              ListTile(
                leading: Icon(Icons.lock),
                title: Text('Change Password'),
                onTap: () {
                  // Navigate to change password page
                },
              ),
              ListTile(
                leading: Icon(Icons.description),
                title: Text('Terms and Conditions'),
                onTap: () {
                  // Navigate to terms and conditions page
                },
              ),
              ListTile(
                leading: Icon(Icons.privacy_tip),
                title: Text('Privacy Policy'),
                onTap: () {
                  // Navigate to privacy policy page
                },
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    // Handle account deletion
                  },
                  child: const Text('Delete Account'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
