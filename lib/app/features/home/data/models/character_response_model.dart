import '../../domain/entities/character_response_entity.dart';
import 'character_info_model.dart';
import 'character_model.dart';

class CharacterResponseModel extends CharacterResponseEntity {
  CharacterResponseModel({required super.info, required super.results});

  factory CharacterResponseModel.fromJson(Map<String, dynamic> json) {
    return CharacterResponseModel(
      info: CharacterInfoModel.fromJson(json['info'] ?? {}),
      results:
          (json['results'] as List<dynamic>?)
              ?.map(
                (item) => CharacterModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'info': (info as CharacterInfoModel).toJson(),
      'results': results
          .map((character) => (character as CharacterModel).toJson())
          .toList(),
    };
  }
}
