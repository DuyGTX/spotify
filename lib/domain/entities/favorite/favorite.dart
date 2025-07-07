// lib/domain/entities/favorite/favorite_song.dart
class FavoriteSongEntity {
  final int id;
  final String userId;
  final int songId;
  final DateTime createdAt;

  FavoriteSongEntity({
    required this.id,
    required this.userId,
    required this.songId,
    required this.createdAt,
  });
}