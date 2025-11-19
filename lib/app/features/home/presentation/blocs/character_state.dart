import 'package:equatable/equatable.dart';

import '../../domain/entities/character_entity.dart';

class CharacterState extends Equatable {
  final List<CharacterEntity> characters;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;
  final String? errorMessage;

  const CharacterState({
    this.characters = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.errorMessage,
  });

  CharacterState copyWith({
    List<CharacterEntity>? characters,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    String? errorMessage,
  }) {
    return CharacterState(
      characters: characters ?? this.characters,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    characters,
    isLoading,
    isLoadingMore,
    hasMore,
    currentPage,
    errorMessage,
  ];
}
