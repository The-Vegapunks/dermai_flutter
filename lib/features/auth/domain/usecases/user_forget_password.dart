import 'package:dermai/features/auth/domain/repository/auth_repository.dart';
import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/core/usecase/usecase.dart';
import 'package:fpdart/src/either.dart';

class UserForgetPassword implements UseCase<String, UserForgetPasswordParams> {
  final AuthRepository repository;
  const UserForgetPassword(this.repository);
  @override
  Future<Either<Failure, String>> call(UserForgetPasswordParams params) async {
    return await repository.forgotPassword(email: params.email);
  }

}

class UserForgetPasswordParams {
  final String email;

  UserForgetPasswordParams({
    required this.email,
  });
}