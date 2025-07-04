import 'package:spotify/domain/entities/song/song.dart';

class SongModel {
  final int id;
  final String songName;
  final String artist;
  final int duration;
  final DateTime releaseDate;
  final String genre;
  final String songUrl;
  final String coverImage;
  final String album;
  final String lyrics; // ✅ mới
  final String lyricsLrc;

  SongModel({
    required this.id,
    required this.songName,
    required this.artist,
    required this.duration,
    required this.releaseDate,
    required this.genre,
    required this.songUrl,
    required this.coverImage,
    required this.album,
    required this.lyrics,
    required this.lyricsLrc,
    
  });

  factory SongModel.fromJson(Map<String, dynamic> data) {
    return SongModel(
      id: data['id'] ?? 0,
      songName: data['song_name'] ?? '',
      artist: data['artist'] ?? '',
      duration: data['duration'] ?? 0,
      releaseDate: _parseDate(data['release_date']),
      genre: data['genre'] ?? '',
      songUrl: data['song_url'] ?? '',
      coverImage: data['cover_image'] ?? '',
      album: data['album'] ?? '',
      lyrics: data['lyrics'] ?? '', // ✅ mới
      lyricsLrc: data['lyrics_lrc'] ?? '',

    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return DateTime(2000);
      }
    }
    return DateTime(2000);
  }
}

extension SongModelX on SongModel {
  SongEntity toEntity() {
    return SongEntity(
      id: id,
      songName: songName,
      artist: artist,
      duration: duration,
      releaseDate: releaseDate,
      genre: genre,
      songUrl: songUrl,
      coverImage: coverImage,
      album: album,
      lyrics: lyrics, // ✅ mới
      lyricsLrc: lyricsLrc, // ✅ mới
    );
  }
}
