part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}
final class AuthSignUp extends AuthEvent {
  final String name;
  final String email;
  final String password;

  AuthSignUp({required this.name, required this.email, required this.password,});
}

final class AuthSignIn extends AuthEvent {
  final String email;
  final String password;

  AuthSignIn({required this.email, required this.password,});
}

final class AuthForgetPassword extends AuthEvent {
  final String email;

  AuthForgetPassword({required this.email, });
}

final class AuthAuthenticated extends AuthEvent {}

final class AuthRecoverPasswordEvent extends AuthEvent {
  final String email;
  final String token;

  AuthRecoverPasswordEvent({required this.email, required this.token,});
}

final class AuthChangePasswordEvent extends AuthEvent {
  final String email;
  final String password;

  AuthChangePasswordEvent({required this.email, required this.password});

}