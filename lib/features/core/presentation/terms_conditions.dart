import 'package:flutter/material.dart';

class TermsConditions extends StatefulWidget {
  const TermsConditions({super.key});

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Terms and Conditions",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.only(
                top: 10, bottom: 40, left: 20, right: 20),
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: 'Last updated: August 6, 2024',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                              color: Colors.deepPurple[50]
                                  ?.withOpacity(0.7)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                paragraphNormal(context,
                    'Welcome to DermAI, an innovative app designed to connect patients with dermatologists, provide AI-driven image classification for skin conditions, and facilitate telemedicine services. By accessing or using DermAI, you agree to be bound by these Terms and Conditions.\n\nPlease read them carefully.\n\n1. Acceptance of Terms \n\n\tBy using DermAI, you agree to comply with and be legally bound by these Terms and Conditions. If you do not agree with any part of these terms, you may not use the app.\n\n2. Services Provided\tDermAI offers the following services:\t\t\n\n• AI image classification for skin conditions\n\n\t\t• Chatbot interaction for health guidance\t\t• Appointment scheduling with dermatologists\t\t• Video consultations with healthcare professionals\t\t\n\n• Access to health tips and articles\n\n3. User Accounts\t• You must create an account to use certain features of DermAI.\n\n\t• You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.\t\n\n• You must notify us immediately of any unauthorized use of your account.\n\n4. Use of the App\t• You agree to use DermAI only for lawful purposes and in accordance with these Terms and Conditions.\n\n\t• You must not use DermAI in any way that could harm, disable, overburden, or impair the app or interfere with any other party’s use of the app.5. Medical Disclaimer\n\n\t• DermAI provides preliminary AI-driven analysis and health guidance but does not offer medical diagnoses or treatment.\t• The information provided by DermAI is for informational purposes only and should not be considered medical advice.\t• Always seek the advice of a qualified healthcare provider with any questions you may have regarding a medical condition.\n\n6. Payments and Subscriptions\t• Certain features of DermAI require payment. These include premium subscriptions, video consultations, and in-app purchases.\t\n\n• Payment for subscriptions will be charged to your payment method on a recurring basis until you cancel.\t\n\n• You can cancel your subscription at any time, but no refunds will be provided for partial subscription periods.7. Privacy\t• Your use of DermAI is also governed by our Privacy Policy, which outlines how we collect, use, and protect your personal information.\t\n\n• By using DermAI, you consent to the collection and use of your information as outlined in the Privacy Policy.\n\n8. Intellectual Property\n\n\t• All content, features, and functionality of DermAI, including but not limited to text, graphics, logos, and software, are the property of DermAI and are protected by copyright, trademark, and other laws.\n\n\t• You are granted a limited, non-exclusive, non-transferable, and revocable license to use DermAI for personal, non-commercial use.9. Limitation of Liability\n\n\t• DermAI is provided on an "as-is" and "as-available" basis. We make no warranties or representations regarding the accuracy or completeness of the app\'s content or services.\n\n\t• To the fullest extent permitted by law, DermAI disclaims all warranties, express or implied, and shall not be liable for any damages of any kind arising from your use of the app.10. Indemnification\n\n\t• You agree to indemnify, defend, and hold harmless DermAI, its officers, directors, employees, and agents from and against any claims, liabilities, damages, losses, and expenses arising out of or in any way connected with your access to or use of the app.')
              ],
            )),
      ),
    );
  }
}

Container titleText(BuildContext context, String titleMessage) {
  return Container(
    width: MediaQuery.sizeOf(context).width,
    // color: Colors.amber,
    child: RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
            text: titleMessage,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ))),
  );
}

RichText paragraphNormal(
    BuildContext context, String paragraphMessage) {
  return RichText(
    textAlign: TextAlign.justify,
    text: TextSpan(
        text: paragraphMessage,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontSize: 15)),
  );
}
