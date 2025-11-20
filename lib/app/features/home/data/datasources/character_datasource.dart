import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../core/cons.dart';
import '../../../../../core/errors/exception.dart';
import '../../../../../core/network/network_info.dart';
import '../models/models.dart';

abstract interface class ICharacterDataSource {
  Future<CharacterResponseModel> getCharacters({int? page});
}

class CharacterDataSourceImpl implements ICharacterDataSource {
  CharacterDataSourceImpl({required this.client, required this.netWorkInfo});
  final http.Client client;
  final NetWorkInfoImpl? netWorkInfo;

  @override
  Future<CharacterResponseModel> getCharacters({int? page}) async {
    if (await netWorkInfo!.isConnected) {
      final pageNumber = page ?? 1;
      final response = await client
          .get(Uri.parse('${AppEnv.baseURL}/character?page=$pageNumber'))
          .timeout(const Duration(seconds: 10));
      return CharacterResponseModel.fromJson(json.decode(response.body));
    } else {
      throw NetWorkException(message: 'Sem conexão a internet');
    }
  }
}
