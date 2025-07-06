class AlbumEntity {
  final int id;
  final String albumName;
  final String albumCover;
  final DateTime releaseDate;
  final int artistId;
  final String artistName;

  AlbumEntity({
    required this.id,
    required this.albumName,
    required this.albumCover,
    required this.releaseDate,
    required this.artistId,
    required this.artistName,
  });
}
