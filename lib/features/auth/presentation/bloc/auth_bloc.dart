import 'package:dermai/features/auth/domain/usecases/current_user.dart';
import 'package:dermai/features/auth/domain/usecases/user_change_password.dart';
import 'package:dermai/features/auth/domain/usecases/user_forget_password.dart';
import 'package:dermai/features/auth/domain/usecases/user_recover_password.dart';
import 'package:dermai/features/auth/domain/usecases/user_sign_in.dart';
import 'package:dermai/features/auth/domain/usecases/user_sign_up.dart';
import 'package:dermai/features/core/cubits/app_user/app_user_cubit.dart';
import 'package:dermai/features/core/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final UserForgetPassword _userForgetPassword;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  final UserRecoverPassword _userRecoverPassword;
  final UserChangePassword _userChangePassword;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required UserForgetPassword userForgetPassword,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
    required UserRecoverPassword userRecoverPassword,
    required UserChangePassword userChangePassword,
  })  : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _userForgetPassword = userForgetPassword,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        _userRecoverPassword = userRecoverPassword,
        _userChangePassword = userChangePassword,
        super(AuthInitial()) {
    on<AuthSignUpEvent>((event, emit) async {
      emit(AuthLoading());
      final response = await _userSignUp(UserSignUpParams(
          name: event.name, email: event.email, password: event.password));
      response.fold(
        (failure) {
          _appUserCubit.updateUser(null);
          emit(AuthFailure(message: failure.message));
        },
        (user) {
          _appUserCubit.updateUser(user);
          emit(AuthSuccess(user: user));
        },
      );
    });
    on<AuthSignInEvent>((event, emit) async {
      emit(AuthLoading());
      final response = await _userSignIn(
          UserSignInParams(email: event.email, password: event.password));
      response.fold(
        (failure) {
          _appUserCubit.updateUser(null);
          emit(AuthFailure(message: failure.message));
        },
        (user) {
          _appUserCubit.updateUser(user);
          emit(AuthSuccess(user: user));
        },
      );
    });
    on<AuthSendOTPEvent>((event, emit) async {
      emit(AuthLoading());
      final response = await _userForgetPassword(
          UserForgetPasswordParams(email: event.email));
      response.fold(
        (failure) => emit(event.resend ? AuthFailureResendOTP(message: failure.message) : AuthFailureSendOTP(message: failure.message)),
        (message) => emit(event.resend ? const AuthSuccessSendOTP() : const AuthSuccessSendOTP()),
      );
    });
    on<AuthAuthenticatedEvent>((event, emit) async {
      final response = await _currentUser(NoParams());
      response.fold(
        (failure) {
          _appUserCubit.updateUser(null);
          emit(AuthFailure(message: failure.message));
        },
        (user) {
          _appUserCubit.updateUser(user);
          emit(AuthSuccess(user: user));
        },
      );
    });

    on<AuthOTPVerificationEvent>((event, emit) async {
      emit(AuthLoading());
      final response = await _userRecoverPassword(
          UserRecoverPasswordParams(email: event.email, token: event.token));
      response.fold((failure) => emit(AuthFailureOTPVerification(message: failure.message)),
          (user) => emit(const AuthSuccessOTPVerification()));
    });

    on<AuthChangePasswordEvent>((event, emit) async {
      emit(AuthLoading());
      final response = await _userChangePassword(UserChangePasswordParams(
          email: event.email, password: event.password));
      response.fold((failure) => emit(AuthFailureChangePassword(message: failure.message)),
          (user) => emit(const AuthSuccessChangePassword()));
    });
  }

}
