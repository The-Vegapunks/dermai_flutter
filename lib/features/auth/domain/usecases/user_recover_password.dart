import 'package:dermai/features/auth/domain/repository/auth_repository.dart';
import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

class UserRecoverPassword implements UseCase<void, UserRecoverPasswordParams> {
  final AuthRepository repository;

  UserRecoverPassword(this.repository);

  @override
  Future<Either<Failure, void>> call(UserRecoverPasswordParams params) async {
    return await repository.verifyOTPForRecovery(email: params.email, token: params.token);
  }
}

class UserRecoverPasswordParams {
  final String email;
  final String token;

  UserRecoverPasswordParams({required this.email, required this.token});
}