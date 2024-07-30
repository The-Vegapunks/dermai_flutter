import 'package:flutter/material.dart';

class AIPage extends StatefulWidget {
  const AIPage({super.key});

  @override
  State<AIPage> createState() => _AIPageState();
}

class _AIPageState extends State<AIPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diagnosis'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button action
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Hello, John\nHow can I help you today?',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            Image.asset(
              'assets/diagnosis_image.png', // Replace with your image asset path
              height: 200.0,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16.0),
            FilledButton.icon(
              onPressed: () {
                // Handle delete image action
              },
              icon: Icon(Icons.delete),
              label: Text('Delete Image'),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                textStyle:
                    TextStyle(color: Theme.of(context).colorScheme.onError),
              ),
            ),
            SizedBox(height: 16.0),
            Card(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'I have red bumps and swelling on the chest. Experiencing fever and tiredness as well as a lost in appetite.\n\nThese bumps started appearing a few days ago and started spreading from the chest to other areas of the body.',
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    // Handle submit case action
                  },
                  child: Text('Submit Case'),
                  // style: ElevatedButton.styleFrom(
                  //   padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                  // ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
