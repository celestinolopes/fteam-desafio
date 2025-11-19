import '../../domain/entities/character_info_entity.dart';

class CharacterInfoModel extends CharacterInfoEntity {
  CharacterInfoModel({
    required super.count,
    required super.pages,
    super.next,
    super.prev,
  });

  factory CharacterInfoModel.fromJson(Map<String, dynamic> json) {
    return CharacterInfoModel(
      count: json['count'] ?? 0,
      pages: json['pages'] ?? 0,
      next: json['next'],
      prev: json['prev'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'pages': pages,
      'next': next,
      'prev': prev,
    };
  }
}


