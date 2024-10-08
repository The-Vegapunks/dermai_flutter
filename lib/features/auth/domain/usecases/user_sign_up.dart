import 'package:dermai/features/auth/domain/repository/auth_repository.dart';
import 'package:dermai/features/core/entities/user.dart';
import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/core/usecase/usecase.dart';
import 'package:fpdart/src/either.dart';

class UserSignUp implements UseCase<User, UserSignUpParams> {
  final AuthRepository repository;
  const UserSignUp(this.repository);
  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    return await repository.signUp(name: params.name, email: params.email, password: params.password);
  }

}

class UserSignUpParams {
  final String name;
  final String email;
  final String password;

  UserSignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}