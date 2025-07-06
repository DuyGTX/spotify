// entities/artist_entity.dart
class ArtistEntity {
  final int id;
  final String name;
  final String? avatarImage;
  final String? bgImage;
  final String? bio;

  ArtistEntity({
    required this.id,
    required this.name,
    this.avatarImage,
    this.bgImage,
    this.bio,
  });
}
