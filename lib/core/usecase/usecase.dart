import 'package:dartz/dartz.dart';

import '../errors/failures.dart' show Failure;

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params? params);
}
