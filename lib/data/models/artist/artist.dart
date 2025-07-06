// models/artist_model.dart


import 'package:spotify/domain/entities/artist/artist.dart';

class ArtistModel {
  final int id;
  final String name;
  final String? avatarImage;
  final String? bgImage;
  final String? bio;

  ArtistModel({
    required this.id,
    required this.name,
    this.avatarImage,
    this.bgImage,
    this.bio,
  });

  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    return ArtistModel(
      id: json['id'],
      name: json['name'],
      avatarImage: json['avatar_image'],
      bgImage: json['bg_image'],
      bio: json['bio'],
    );
  }

  ArtistEntity toEntity() => ArtistEntity(
        id: id,
        name: name,
        avatarImage: avatarImage,
        bgImage: bgImage,
        bio: bio,
      );
}
