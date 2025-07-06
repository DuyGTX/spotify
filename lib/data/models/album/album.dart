import 'package:spotify/domain/entities/album/album.dart';

class AlbumModel {
  final int id;
  final String albumName;
  final String albumCover;
  final DateTime releaseDate;
  final int artistId;
  final String artistName;

  AlbumModel({
    required this.id,
    required this.albumName,
    required this.albumCover,
    required this.releaseDate,
    required this.artistId,
    required this.artistName,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> data) {
    return AlbumModel(
      id: data['id'] ?? 0,
      albumName: data['album_name'] ?? '',
      albumCover: data['album_cover'] ?? '',
      releaseDate: DateTime.tryParse(data['release_date'] ?? '') ?? DateTime(2000),
      artistId: data['artist_id'] ?? 0,
      artistName: data['Artists']?['name'] ?? '',
    );
  }

  AlbumEntity toEntity() {
    return AlbumEntity(
      id: id,
      albumName: albumName,
      albumCover: albumCover,
      releaseDate: releaseDate,
      artistId: artistId,
      artistName: artistName,
    );
  }
}
