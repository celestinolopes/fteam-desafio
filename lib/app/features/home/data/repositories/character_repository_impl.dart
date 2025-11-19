import 'package:dartz/dartz.dart';

import '../../../../../../core/errors/exception.dart';
import '../../../../../core/errors/failures.dart';
import '../../domain/entities/character_response_entity.dart';
import '../../domain/repositories/character_repository.dart';
import '../datasources/character_datasource.dart';

class CharacterRepositoryImpl implements ICharacterRepository {
  CharacterRepositoryImpl({required this.characterDataSource});
  final CharacterDataSourceImpl characterDataSource;
  @override
  Future<Either<Failure, CharacterResponseEntity>> getCharacters({
    int? page,
  }) async {
    try {
      final characters = await characterDataSource.getCharacters(page: page);
      return Right(characters);
    } on ServerException {
      return Left(ServerFailure(message: "Ocorreu um erro no servidor"));
    } on NetWorkException {
      return Left(NetWorkFailure(message: "Sem conexão a internet"));
    }
  }
}
