import 'package:dermai/shared/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, String>> signIn({ required String email, required String password });
  Future<Either<Failure, String>> signUp({ required String name, required String email, required String password });
  Future<Either<Failure, String>> signOut();
  Future<Either<Failure, String>> forgotPassword({ required String email });
}