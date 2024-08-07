import 'package:dermai/features/auth/domain/repository/auth_repository.dart';
import 'package:dermai/features/core/error/failure.dart';
import 'package:dermai/features/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

class UserDeleteAccount implements UseCase<void, NoDeleteParams> {
  final AuthRepository repository;

  const UserDeleteAccount(this.repository);

  @override
  Future<Either<Failure, void>> call(NoDeleteParams params) async {
    return await repository.deleteAccount();
  }
}

class NoDeleteParams {}
