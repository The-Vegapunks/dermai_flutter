import 'package:dermai/features/auth/domain/repository/auth_repository.dart';
import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/core/usecase/usecase.dart';
import 'package:fpdart/src/either.dart';

class UserChangePassword implements UseCase<void, UserChangePasswordParams> {
  final AuthRepository repository;
  const UserChangePassword(this.repository);
  @override
  Future<Either<Failure, void>> call(UserChangePasswordParams params) async {
    return await repository.changePassword(email: params.email, password: params.password);
  }

}

class UserChangePasswordParams {
  final String email;
  final String password;

  UserChangePasswordParams({
    required this.email,
    required this.password
  });
}