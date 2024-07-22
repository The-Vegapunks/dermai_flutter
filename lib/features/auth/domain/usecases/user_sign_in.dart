import 'package:dermai/features/auth/domain/repository/auth_repository.dart';
import 'package:dermai/features/core/entities/user.dart';
import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/core/usecase/usecase.dart';
import 'package:fpdart/src/either.dart';

class UserSignIn implements UseCase<User, UserSignInParams> {
  final AuthRepository repository;
  const UserSignIn(this.repository);
  @override
  Future<Either<Failure, User>> call(UserSignInParams params) async {
    return await repository.signIn(email: params.email, password: params.password);
  }

}

class UserSignInParams {
  final String email;
  final String password;

  UserSignInParams({
    required this.email,
    required this.password,
  });
}