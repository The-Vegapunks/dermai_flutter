import 'package:dermai/features/auth/domain/usecases/current_user.dart';
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

  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required UserForgetPassword userForgetPassword,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
    required UserRecoverPassword userRecoverPassword,
  })  : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _userForgetPassword = userForgetPassword,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        _userRecoverPassword = userRecoverPassword,
        super(AuthInitial()) {
    on<AuthSignUp>((event, emit) async {
      emit(AuthLoading());
      final response = await _userSignUp(UserSignUpParams(
          name: event.name, email: event.email, password: event.password));
      response.fold(
        (failure) => _emitAuthFailure(failure.message, emit),
        (user) => _emitAuthSuccess(user, emit),
      );
    });
    on<AuthSignIn>((event, emit) async {
      emit(AuthLoading());
      final response = await _userSignIn(
          UserSignInParams(email: event.email, password: event.password));
      response.fold(
        (failure) => _emitAuthFailure(failure.message, emit),
        (user) => _emitAuthSuccess(user, emit),
      );
    });
    on<AuthForgetPassword>((event, emit) async {
      emit(AuthLoading());
      final response = await _userForgetPassword(
          UserForgetPasswordParams(email: event.email));
      response.fold(
        (failure) => _emitAuthFailure(failure.message, emit),
        (message) => emit(const AuthSuccess(user: null)),
      );
    });
    on<AuthAuthenticated>((event, emit) async {
      final response = await _currentUser(NoParams());
      response.fold(
        (failure) => _emitAuthFailure(failure.message, emit),
        (user) => _emitAuthSuccess(user, emit),
      );
    });

    on<AuthRecoverPassword>((event, emit) async {
      emit(AuthLoading());
      final response = await _userRecoverPassword(UserRecoverPasswordParams(
          email: event.email, password: event.password, token: event.token));
      response.fold(
        (failure) => _emitAuthFailure(failure.message, emit),
        (user) => _emitAuthSuccess(user, emit),
      );
    });
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }

  void _emitAuthFailure(String message, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(null);
    emit(AuthFailure(message: message));
  }
}
