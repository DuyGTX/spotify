import 'package:equatable/equatable.dart';
import 'package:spotify/domain/entities/album/album.dart';

abstract class TrendingAlbumState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TrendingAlbumInitial extends TrendingAlbumState {}

class TrendingAlbumLoading extends TrendingAlbumState {}

class TrendingAlbumLoaded extends TrendingAlbumState {
  final List<AlbumEntity> albums;

  TrendingAlbumLoaded(this.albums);

  @override
  List<Object?> get props => [albums];
}

class TrendingAlbumError extends TrendingAlbumState {
  final String message;

  TrendingAlbumError(this.message);

  @override
  List<Object?> get props => [message];
}
