part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final User user;
  const AuthSuccess({required this.user});
}

final class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});
}

final class AuthSuccessOTPVerification extends AuthState {
  const AuthSuccessOTPVerification();
}

final class AuthFailureOTPVerification extends AuthState {
  final String message;

  const AuthFailureOTPVerification({required this.message});
}

final class AuthSuccessSendOTP extends AuthState {
  const AuthSuccessSendOTP();
}

final class AuthFailureSendOTP extends AuthState {
  final String message;

  const AuthFailureSendOTP({required this.message});
}

final class AuthSuccessResendOTP extends AuthState {
  const AuthSuccessResendOTP();
}

final class AuthFailureResendOTP extends AuthState {
  final String message;

  const AuthFailureResendOTP({required this.message});
}

final class AuthSuccessChangePassword extends AuthState {
  const AuthSuccessChangePassword();
}

final class AuthFailureChangePassword extends AuthState {
  final String message;

  const AuthFailureChangePassword({required this.message});
}

final class AuthSuccessDeleteAccount extends AuthState {
  const AuthSuccessDeleteAccount();
}

final class AuthFailureDeleteAccount extends AuthState {
  final String message;

  const AuthFailureDeleteAccount({required this.message});
}
