import 'package:dermai/features/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

abstract interface class UseCaseStream<SuccessType, Params> {
  SuccessType call(Params params);
}

