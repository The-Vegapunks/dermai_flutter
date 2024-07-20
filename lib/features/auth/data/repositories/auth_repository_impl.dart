import 'package:dermai/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:dermai/features/auth/domain/repository/auth_repository.dart';
import 'package:dermai/shared/error/failure.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  const AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> forgotPassword({
    required String email,
  }) {
    // TODO: implement forgotPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> signIn({
    required String email,
    required String password,
  }) {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userID = await remoteDataSource.signUp(
        name: name,
        email: email,
        password: password,
      );

      return right(userID);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
