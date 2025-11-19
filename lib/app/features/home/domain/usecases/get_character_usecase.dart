import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecase/usecase.dart' show UseCase;
import '../entities/character_response_entity.dart';
import '../repositories/repositories.dart';

class GetCharacterUsecase implements UseCase<CharacterResponseEntity, int> {
  final ICharacterRepository characterRepository;

  GetCharacterUsecase({required this.characterRepository});

  @override
  Future<Either<Failure, CharacterResponseEntity>> call(int? params) async {
    final result = await characterRepository.getCharacters(page: params);
    return result;
  }
}
