import 'package:dermai/features/auth/presentation/pages/reset_password_page.dart';
import 'package:dermai/features/auth/presentation/pages/welcome_page.dart';
import 'package:dermai/features/core/presentation/privacy_policy.dart';
import 'package:dermai/features/core/presentation/terms_conditions.dart';
import 'package:dermai/features/patient/presentation/bloc/patient_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Change Password'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordPage(email : "dkefkf")));
              },
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text('Terms and Conditions'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsConditions()));
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text('Privacy Policy'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicy()));
              },
            ),
            const SizedBox(height: 505),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 400,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () {
                    // Handle account deletion
                  },
                  child: const Text('Delete Account'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
