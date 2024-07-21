import 'package:dermai/features/auth/presentation/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' as vid;
import 'package:stream_video/src/models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final supabase = await Supabase.initialize(url: const String.fromEnvironment("supabaseUrl"), anonKey: const String.fromEnvironment("supabaseKey"));

    WidgetsFlutterBinding.ensureInitialized();

  // Right after creation client connects to the backend and authenticates the user.
  // You can set `options: StreamVideoOptions(autoConnect: false)` if you want to disable auto-connect.
  final client = vid.StreamVideo(
    'mmhfdzb5evj2',
    user: vid.User.regular(userId: 'Barriss_Offee', role: 'admin', name: 'John Doe'),
    userToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiVGFsb25fS2FycmRlIiwiaXNzIjoiaHR0cHM6Ly9wcm9udG8uZ2V0c3RyZWFtLmlvIiwic3ViIjoidXNlci9UYWxvbl9LYXJyZGUiLCJpYXQiOjE3MjE1MzYxNjgsImV4cCI6MTcyMjE0MDk3M30._36Jx_65SveNtfuZMpV-F2gPq8dpNkQnnpYSB74Fd-U',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DermAI',
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          },
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const WelcomePage(),
    );
  }
}
