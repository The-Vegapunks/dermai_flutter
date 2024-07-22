part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {}

final class AppUserInitial extends AppUserState {}

final class AppUserNotAuthenticated extends AppUserState {}

final class AppUserAuthenticated extends AppUserState {
  final User user;
  AppUserAuthenticated({required this.user});
}
