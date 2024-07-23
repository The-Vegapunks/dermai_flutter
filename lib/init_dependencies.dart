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
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final supabase = await Supabase.initialize(
      url: Env.superbaseUrl, anonKey: Env.superbaseAnonKey);
  Gemini.init(apiKey: Env.geminiKey);
  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  _initAuth();
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      client: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserSignUp(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => UserSignIn(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => UserForgetPassword(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => CurrentUser(
      serviceLocator(),
    )
  );
  serviceLocator.registerFactory(
    () => UserRecoverPassword(
      serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator<UserSignUp>(),
      userSignIn: serviceLocator<UserSignIn>(),
      userForgetPassword: serviceLocator<UserForgetPassword>(),
      currentUser: serviceLocator<CurrentUser>(),
      appUserCubit: serviceLocator<AppUserCubit>(),
      userRecoverPassword: serviceLocator<UserRecoverPassword>(),
    ),
  );
}
