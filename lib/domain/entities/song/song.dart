class SongEntity {
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

  SongEntity({
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

  /// Factory constructor chuyển đổi từ Map search result sang SongEntity
  factory SongEntity.fromMap(Map<String, dynamic> s) {
  return SongEntity(
    id: s['id'] ?? 0,
    songName: s['song_name'] ?? '',
    duration: s['duration'] ?? 0,
    releaseDate: s['release_date'] is String
        ? DateTime.tryParse(s['release_date']) ?? DateTime(2000)
        : (s['release_date'] ?? DateTime(2000)),
    genre: s['genre'] ?? '',
    songUrl: s['song_url'] ?? '',
    coverImage: s['cover_image'] ?? '',
    lyrics: s['lyrics'] ?? '',
    lyricsLrc: s['lyrics_lrc'] ?? '',
    artistId: s['artist_id'] ?? 0,
    albumId: s['album_id'] ?? 0,
    // Lấy tên nghệ sĩ từ Artists
    artistName: (s['Artists'] != null && s['Artists'] is Map && s['Artists']['name'] != null)
        ? s['Artists']['name']
        : '',
  );
}

}
