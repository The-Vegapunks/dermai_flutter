import 'package:dermai/env/env.dart';
import 'package:dermai/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:dermai/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dermai/features/auth/domain/repository/auth_repository.dart';
import 'package:dermai/features/auth/domain/usecases/current_user.dart';
import 'package:dermai/features/auth/domain/usecases/user_forget_password.dart';
import 'package:dermai/features/auth/domain/usecases/user_recover_password.dart';
import 'package:dermai/features/auth/domain/usecases/user_sign_in.dart';
import 'package:dermai/features/auth/domain/usecases/user_sign_up.dart';
import 'package:dermai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dermai/features/core/cubits/app_user/app_user_cubit.dart';
import 'package:dermai/features/doctor/data/data_sources/doctor_remote_data_source.dart';
import 'package:dermai/features/doctor/data/repository/doctor_repository_impl.dart';
import 'package:dermai/features/doctor/domain/repository/doctor_repository.dart';
import 'package:dermai/features/doctor/domain/usecases/doctor_call_patient.dart';
import 'package:dermai/features/doctor/domain/usecases/doctor_connect_stream.dart';
import 'package:dermai/features/doctor/domain/usecases/doctor_get_appointments.dart';
import 'package:dermai/features/doctor/domain/usecases/doctor_get_available_appointment_slots.dart';
import 'package:dermai/features/doctor/domain/usecases/doctor_get_case_details.dart';
import 'package:dermai/features/doctor/domain/usecases/doctor_get_cases.dart';
import 'package:dermai/features/doctor/domain/usecases/doctor_sign_out_usecase.dart';
import 'package:dermai/features/doctor/domain/usecases/doctor_update_case_details.dart';
import 'package:dermai/features/doctor/domain/usecases/doctor_cancel_appointment.dart' as usecasecancel;
import 'package:dermai/features/doctor/domain/usecases/doctor_update_appointment.dart' as usecaseupdate;
import 'package:dermai/features/doctor/presentation/bloc/doctor_bloc.dart';
import 'package:dermai/features/patient/data/data_sources/patient_remote_data_source.dart';
import 'package:dermai/features/patient/data/repository/patient_repository_impl.dart';
import 'package:dermai/features/patient/domain/repository/patient_repository.dart';
import 'package:dermai/features/patient/domain/usecases/patient_call_doctor.dart';
import 'package:dermai/features/patient/domain/usecases/patient_cancel_appointment.dart';
import 'package:dermai/features/patient/domain/usecases/patient_connect_stream.dart';
import 'package:dermai/features/patient/domain/usecases/patient_get_appointments.dart';
import 'package:dermai/features/patient/domain/usecases/patient_get_diagnosed_diseases.dart';
import 'package:dermai/features/patient/domain/usecases/patient_get_messages.dart';
import 'package:dermai/features/patient/domain/usecases/patient_send_message.dart';
import 'package:dermai/features/patient/domain/usecases/patient_sign_out_usecase.dart';
import 'package:dermai/features/patient/domain/usecases/patient_submit_case.dart';
import 'package:dermai/features/patient/presentation/bloc/patient_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final supabase = await Supabase.initialize(
      url: Env.superbaseUrl, anonKey: Env.superbaseAnonKey);
  Gemini.init(apiKey: Env.geminiKey);
  final gemini = Gemini.instance;

  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerLazySingleton(() => gemini);
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  _initAuth();
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        client: serviceLocator(),
      ),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserSignIn(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserForgetPassword(
        serviceLocator(),
      ),
    )
    ..registerFactory(() => CurrentUser(
          serviceLocator(),
        ))
    ..registerFactory(
      () => UserRecoverPassword(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator<UserSignUp>(),
        userSignIn: serviceLocator<UserSignIn>(),
        userForgetPassword: serviceLocator<UserForgetPassword>(),
        currentUser: serviceLocator<CurrentUser>(),
        appUserCubit: serviceLocator<AppUserCubit>(),
        userRecoverPassword: serviceLocator<UserRecoverPassword>(),
      ),
    );

  serviceLocator
  ..registerFactory<PatientRemoteDataSource>(
    () => PatientRemoteDataSourceImpl(client: serviceLocator(), gemini: serviceLocator()),
  )
  ..registerFactory<PatientRepository>(
    () => PatientRepositoryImpl(remoteDataSource: serviceLocator()),
  )
  ..registerFactory(
    () => PatientGetDiagnosedDiseases(serviceLocator()),
  )
  ..registerFactory(
    () => PatientSignOutUsecase(serviceLocator()),
  )
  ..registerFactory(
    () => PatientGetAppointments(serviceLocator()),
  )
  ..registerFactory(
    () => PatientSubmitCase(serviceLocator()),
  )
  ..registerFactory(
    () => PatientCancelAppointment(serviceLocator())
  )
  ..registerFactory(
    () => PatientSendMessage(serviceLocator()),
  )
  ..registerFactory(
    () => PatientGetMessages(serviceLocator()),
  )
  ..registerFactory(
    () => PatientConnectStream(serviceLocator()),
  )
  ..registerFactory(
    () => PatientCallDoctor(serviceLocator()),
  )
  ..registerLazySingleton(
    () => PatientBloc(
      patientGetDiagnosedDiseases: serviceLocator(),
      patientSignOut: serviceLocator(),
      patientGetAppointments: serviceLocator(),
      patientSubmitCase: serviceLocator(),
      patientCancelAppointment: serviceLocator(),
      patientGetMessages: serviceLocator(),
      patientSendMessage: serviceLocator(),
      patientConnectStream: serviceLocator(),
      patientCallDoctor: serviceLocator(),
    ),
  );

  serviceLocator
  ..registerFactory<DoctorRemoteDataSource>(
    () => DoctorRemoteDataSourceImpl(client: serviceLocator()),
  )
  ..registerFactory<DoctorRepository>(
    () => DoctorRepositoryImpl(remoteDataSource: serviceLocator()),
  )
  ..registerFactory<DoctorGetCases>(
    () => DoctorGetCases(serviceLocator()),
  )
  ..registerFactory(
    () => DoctorGetCaseDetails(serviceLocator()),
  )
  ..registerFactory(
    () => DoctorUpdateCaseDetails(serviceLocator()),
  )
  ..registerFactory(
    () => DoctorGetAppointments(serviceLocator()),
  )
  ..registerFactory(
    () => usecasecancel.DoctorCancelAppointment(serviceLocator()),
  )
  ..registerFactory(
    () => DoctorGetAvailableAppointmentSlots(serviceLocator()),
  )
  ..registerFactory(
    () => usecaseupdate.DoctorUpdateAppointment(serviceLocator()),
  )
  ..registerFactory(
    () => DoctorSignOutUsecase(serviceLocator()),
  )
  ..registerFactory(
    () => DoctorConnectStream(serviceLocator()),
  )
  ..registerFactory(
    () => DoctorCallPatient(serviceLocator()),
  )
  ..registerLazySingleton(
    () => DoctorBloc(
      doctorGetDiagnosedDiseases: serviceLocator<DoctorGetCases>(),
      doctorGetCaseDetails: serviceLocator<DoctorGetCaseDetails>(),
      doctorUpdateCaseDetails: serviceLocator<DoctorUpdateCaseDetails>(),
      doctorGetAppointments: serviceLocator<DoctorGetAppointments>(),
      doctorCancelAppointment: serviceLocator<usecasecancel.DoctorCancelAppointment>(),
      doctorGetAvailableAppointmentSlots: serviceLocator<DoctorGetAvailableAppointmentSlots>(),
      doctorUpdateAppointment: serviceLocator<usecaseupdate.DoctorUpdateAppointment>(),
      doctorSignOut: serviceLocator<DoctorSignOutUsecase>(),
      doctorConnectStream: serviceLocator<DoctorConnectStream>(),
      doctorCallPatient: serviceLocator<DoctorCallPatient>(),
    ),
  );
}
