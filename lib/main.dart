import 'package:dermai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dermai/features/auth/presentation/pages/welcome_page.dart';
import 'package:dermai/features/core/cubits/app_user/app_user_cubit.dart';
import 'package:dermai/features/core/presentation/theme.dart';
import 'package:dermai/features/doctor/presentation/bloc/doctor_bloc.dart';
import 'package:dermai/features/patient/presentation/bloc/patient_bloc.dart';
import 'package:dermai/features/patient/presentation/pages/root_page.dart'
    as patient;
import 'package:dermai/features/doctor/presentation/pages/root_page.dart'
    as doctor;
import 'package:dermai/init_dependencies.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  // Right after creation client connects to the backend and authenticates the user.
  // You can set `options: StreamVideoOptions(autoConnect: false)` if you want to disable auto-connect.
  // final client = vid.StreamVideo(
  //   'mmhfdzb5evj2',
  //   user: vid.User.regular(
  //       userId: 'Barriss_Offee', role: 'admin', name: 'John Doe'),
  //   userToken:
  //       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiVGFsb25fS2FycmRlIiwiaXNzIjoiaHR0cHM6Ly9wcm9udG8uZ2V0c3RyZWFtLmlvIiwic3ViIjoidXNlci9UYWxvbl9LYXJyZGUiLCJpYXQiOjE3MjE1MzYxNjgsImV4cCI6MTcyMjE0MDk3M30._36Jx_65SveNtfuZMpV-F2gPq8dpNkQnnpYSB74Fd-U',
  // );

  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (_) => serviceLocator<AppUserCubit>(),
    ),
    BlocProvider(
      create: (_) => serviceLocator<AuthBloc>(),
    ),
    BlocProvider(
      create: (_) => serviceLocator<PatientBloc>(),
    ),
    BlocProvider(
      create: (_) => serviceLocator<DoctorBloc>(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((duration) {
      context.read<AuthBloc>().add(AuthAuthenticatedEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      if (lightDynamic != null && darkDynamic != null) {
        (lightDynamic, darkDynamic) =
            generateDynamicColorSchemes(lightDynamic, darkDynamic);
      }
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DermAI',
        themeMode: ThemeMode.system,
        theme: ThemeData(
          colorScheme:
              lightDynamic ?? ColorScheme.fromSeed(seedColor: Colors.purple),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: darkDynamic ??
              ColorScheme.fromSeed(
                  seedColor: Colors.purple, brightness: Brightness.dark),
          useMaterial3: true,
        ),
        home: BlocSelector<AppUserCubit, AppUserState, AppUserState>(
          selector: (state) {
            return state;
          },
          builder: (context, state) {
            if (state is AppUserInitial) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state is AppUserAuthenticated) {
              final user = state.user;
              if (user.isDoctor) {
                return const doctor.RootPage();
              } else {
                return const patient.RootPage();
              }
            } else {
              return const WelcomePage();
            }
          },
        ),
      );
    });
  }
}
