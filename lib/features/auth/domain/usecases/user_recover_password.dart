import 'package:dermai/features/auth/domain/repository/auth_repository.dart';
import 'package:dermai/features/core/entities/user.dart';
import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

class UserRecoverPassword implements UseCase<User, UserRecoverPasswordParams> {
  final AuthRepository repository;

  UserRecoverPassword(this.repository);

  @override
  Future<Either<Failure, User>> call(UserRecoverPasswordParams params) async {
    return await repository.verifyOTPForRecovery(email: params.email, password: params.password, token: params.token);
  }
}

class UserRecoverPasswordParams {
  final String email;
  final String password;
  final String token;

  UserRecoverPasswordParams({required this.email, required this.password, required this.token});
}