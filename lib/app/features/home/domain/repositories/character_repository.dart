import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/character_response_entity.dart';

abstract class ICharacterRepository {
  /// Busca todos os personagens com paginação opcional
  ///
  /// [page] - Número da página (opcional, padrão: 1)
  /// Retorna [CharacterResponseEntity] com a lista de personagens e informações de paginação
  Future<Either<Failure, CharacterResponseEntity>> getCharacters({int? page});
}
