import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/character_cubit.dart';
import '../blocs/character_state.dart';
import '../widgets/character_card.dart';
import '../widgets/character_list_item.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<CharacterCubit>().loadCharacters();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<CharacterCubit>().loadMoreCharacters();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty Characters'),
        centerTitle: true,
      ),
      body: BlocBuilder<CharacterCubit, CharacterState>(
        builder: (context, state) {
          if (state.characters.isEmpty && state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null && state.characters.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage!,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () =>
                        context.read<CharacterCubit>().loadCharacters(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          // Lista de personagens
          return RefreshIndicator(
            onRefresh: () => context.read<CharacterCubit>().refreshCharacters(),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: state.characters.length + (state.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                // Se chegou no final e ainda tem mais páginas, mostra loading
                if (index >= state.characters.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return CharacterListItem(
                  index: index,
                  itemCount: state.characters.length + (state.hasMore ? 1 : 0),
                  isLoadingMore: state.isLoadingMore,
                  characterCard: CharacterCard(
                    character: state.characters[index],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
