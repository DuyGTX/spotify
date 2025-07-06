import 'package:spotify/domain/entities/song/song.dart';

class SongModel {
  final int id;
  final String songName;
  final int duration;
  final DateTime releaseDate;
  final String genre;
  final String songUrl;
  final String coverImage;
  final String lyrics;
  final String lyricsLrc;
  final String artistName;
  final int artistId;
  final int albumId;

  SongModel({
    required this.id,
    required this.songName,
    required this.duration,
    required this.releaseDate,
    required this.genre,
    required this.songUrl,
    required this.coverImage,
    required this.lyrics,
    required this.lyricsLrc,
    required this.artistId,
    required this.albumId,
    required this.artistName,
  });

  factory SongModel.fromJson(Map<String, dynamic> data) {
    return SongModel(
      id: data['id'] ?? 0,
      songName: data['song_name'] ?? '',
      duration: data['duration'] ?? 0,
      releaseDate: DateTime.tryParse(data['release_date'] ?? '') ?? DateTime(2000),
      genre: data['genre'] ?? '',
      songUrl: data['song_url'] ?? '',
      coverImage: data['cover_image'] ?? '',
      lyrics: data['lyrics'] ?? '',
      lyricsLrc: data['lyrics_lrc'] ?? '',
      artistId: data['artist_id'] ?? 0,
      albumId: data['album_id'] ?? 0,
      artistName: (data['Artists'] != null ? data['Artists']['name'] : '') ?? '',

    );
  }
}

extension SongModelX on SongModel {
  SongEntity toEntity() {
    return SongEntity(
      id: id,
      songName: songName,
      duration: duration,
      releaseDate: releaseDate,
      genre: genre,
      songUrl: songUrl,
      coverImage: coverImage,
      lyrics: lyrics,
      lyricsLrc: lyricsLrc,
      artistId: artistId,
      albumId: albumId,
      artistName: artistName,
    );
  }
}
