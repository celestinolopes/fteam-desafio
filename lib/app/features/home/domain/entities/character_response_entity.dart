import 'character_entity.dart';
import 'character_info_entity.dart';

class CharacterResponseEntity {
  final CharacterInfoEntity info;
  final List<CharacterEntity> results;

  CharacterResponseEntity({required this.info, required this.results});
}
