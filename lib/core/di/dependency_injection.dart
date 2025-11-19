import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../app/features/home/data/datasources/character_datasource.dart';
import '../../app/features/home/data/repositories/character_repository_impl.dart';
import '../../app/features/home/domain/repositories/character_repository.dart';
import '../../app/features/home/domain/usecases/get_character_usecase.dart';
import '../../app/features/home/presentation/blocs/character_cubit.dart';
import '../network/network_info.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerLazySingleton(() => http.Client());

  getIt.registerLazySingleton(() => InternetConnectionChecker.createInstance());

  getIt.registerLazySingleton<NetWorkInfoImpl>(
    () => NetWorkInfoImpl(connectionChecker: getIt()),
  );

  getIt.registerSingleton<CharacterDataSourceImpl>(
    CharacterDataSourceImpl(client: getIt(), netWorkInfo: getIt()),
  );
  getIt.registerLazySingleton<ICharacterRepository>(
    () => CharacterRepositoryImpl(characterDataSource: getIt()),
  );
  getIt.registerLazySingleton(
    () => GetCharacterUsecase(characterRepository: getIt()),
  );

  // Bloc/Cubit
  getIt.registerFactory(() => CharacterCubit(getCharacterUsecase: getIt()));
}
