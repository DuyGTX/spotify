


import 'package:spotify/domain/entities/favorite/favorite.dart';

class FavoriteSongModel {
  final int id;
  final String userId;
  final int songId;
  final DateTime createdAt;

  FavoriteSongModel({
    required this.id,
    required this.userId,
    required this.songId,
    required this.createdAt,
  });

  factory FavoriteSongModel.fromJson(Map<String, dynamic> json) {
    return FavoriteSongModel(
      id: json['id'],
      userId: json['user_id'],
      songId: json['song_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'song_id': songId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  FavoriteSongEntity toEntity() {
    return FavoriteSongEntity(
      id: id,
      userId: userId,
      songId: songId,
      createdAt: createdAt,
    );
  }
}