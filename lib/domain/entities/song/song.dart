class SongEntity {
  final int id;
  final String songName;
  final String artist;
  final int duration;
  final DateTime releaseDate;
  final String genre;
  final String songUrl;
  final String coverImage;
  final String album;

  SongEntity({
    required this.id,
    required this.songName,
    required this.artist,
    required this.duration,
    required this.releaseDate,
    required this.genre,
    required this.songUrl,
    required this.coverImage,
    required this.album,
  });
}
