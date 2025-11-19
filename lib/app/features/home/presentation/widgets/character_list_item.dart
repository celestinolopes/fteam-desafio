import 'package:flutter/material.dart';

/// Widget que exibe um item da lista ou o indicador de loading
class CharacterListItem extends StatelessWidget {
  final int index;
  final int itemCount;
  final bool isLoadingMore;
  final Widget characterCard;

  const CharacterListItem({
    super.key,
    required this.index,
    required this.itemCount,
    required this.isLoadingMore,
    required this.characterCard,
  });

  @override
  Widget build(BuildContext context) {
    // Se é o último item e está carregando mais, mostra o loading
    if (index == itemCount - 1 && isLoadingMore) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return characterCard;
  }
}

