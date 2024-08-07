part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthAuthenticatedEvent extends AuthEvent {}

final class AuthSignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  AuthSignUpEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}

final class AuthSignInEvent extends AuthEvent {
  final String email;
  final String password;

  AuthSignInEvent({
    required this.email,
    required this.password,
  });
}

final class AuthSendOTPEvent extends AuthEvent {
  final String email;
  final bool resend;

  AuthSendOTPEvent({required this.email, required this.resend});
}

final class AuthOTPVerificationEvent extends AuthEvent {
  final String email;
  final String token;

  AuthOTPVerificationEvent({
    required this.email,
    required this.token,
  });
}

final class AuthChangePasswordEvent extends AuthEvent {
  final String email;
  final String password;

  AuthChangePasswordEvent({required this.email, required this.password});
}
