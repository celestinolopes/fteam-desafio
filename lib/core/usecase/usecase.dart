import 'package:dartz/dartz.dart';

import '../errors/failures.dart' show Failure;

abstract interface class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params? params);
}
