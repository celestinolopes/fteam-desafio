import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/usecases/get_character_usecase.dart';
import 'character_state.dart';

class CharacterCubit extends Cubit<CharacterState> {
  final GetCharacterUsecase getCharacterUsecase;

  CharacterCubit({required this.getCharacterUsecase})
    : super(const CharacterState());

  Future<void> loadCharacters() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await getCharacterUsecase(1);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: _mapFailureToMessage(failure),
          ),
        );
      },
      (response) {
        emit(
          state.copyWith(
            characters: response.results,
            isLoading: false,
            hasMore: response.info.next != null,
            currentPage: 1,
          ),
        );
      },
    );
  }

  Future<void> loadMoreCharacters() async {
    if (state.isLoadingMore || !state.hasMore) return;

    final nextPage = state.currentPage + 1;

    emit(state.copyWith(isLoadingMore: true));

    final result = await getCharacterUsecase(nextPage);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoadingMore: false,
            errorMessage: _mapFailureToMessage(failure),
          ),
        );
      },
      (response) {
        emit(
          state.copyWith(
            characters: [...state.characters, ...response.results],
            isLoadingMore: false,
            hasMore: response.info.next != null,
            currentPage: nextPage,
          ),
        );
      },
    );
  }

  Future<void> refreshCharacters() async {
    await loadCharacters();
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is NetWorkFailure) {
      return failure.message;
    }
    return 'Erro desconhecido';
  }
}
