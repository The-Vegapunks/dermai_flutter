import 'package:dermai/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:dermai/features/auth/domain/repository/auth_repository.dart';
import 'package:dermai/features/core/entities/user.dart';
import 'package:dermai/features/core/error/exception.dart';
import 'package:dermai/features/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  const AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> forgotPassword({
    required String email,
  }) async {
    try {
      final message = await remoteDataSource.forgotPassword(email: email);

      return right(message);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  }) async{
    try {
      final user = await remoteDataSource.signIn(
        email: email,
        password: password,
      );

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signUp(
        name: name,
        email: email,
        password: password,
      );
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
  
  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure('User not signed in'));
      } else {
        return right(user);
      }
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
  
  @override
  Future<Either<Failure, void>> verifyOTPForRecovery({required String email, required String token}) async {
    try {
      final user = await remoteDataSource.verifyOTPForRecovery(
        email: email,
        token: token,
      );

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
  
  @override
  Future<Either<Failure, void>> changePassword({required String email, required String password}) async {
    try {
      await remoteDataSource.changePassword(
        email: email,
        password: password,
      );

      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  

}
