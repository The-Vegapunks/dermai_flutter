import 'package:dermai/features/core/entities/user.dart';
import 'package:dermai/features/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signIn({ required String email, required String password });
  Future<Either<Failure, User>> signUp({ required String name, required String email, required String password });
  Future<Either<Failure, String>> forgotPassword({ required String email });
  Future<Either<Failure, User>> currentUser();

}