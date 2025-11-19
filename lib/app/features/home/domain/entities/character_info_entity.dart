class CharacterInfoEntity {
  final int count;
  final int pages;
  final String? next;
  final String? prev;

  CharacterInfoEntity({
    required this.count,
    required this.pages,
    this.next,
    this.prev,
  });
}
