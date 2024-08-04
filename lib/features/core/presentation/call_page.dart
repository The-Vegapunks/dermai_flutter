import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class CallPage extends StatefulWidget {
  final Call call;

  const CallPage({
    super.key,
    required this.call,
  });

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamCallContainer(
          call: widget.call,
        ),
      ),
    );
  }
}
