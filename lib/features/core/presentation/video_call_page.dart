// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:dermai/features/core/presentation/Call_screen.dart';


class VideoCallPage extends StatelessWidget {
  const VideoCallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Video Call"),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("Create Call"),
          onPressed: () async {
            try {
              
              var call = StreamVideo.instance.makeCall(
                callType: StreamCallType(),
                id: 'Demo-call-123',
              );

              await call.getOrCreate();

              // Created ahead
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CallScreen(call: call),
                ),
              );
            } catch (e) {
              debugPrint('Error joining or creating call: $e');
              debugPrint(e.toString());
            }
          },
        ),
      ),
    );
  }
}
