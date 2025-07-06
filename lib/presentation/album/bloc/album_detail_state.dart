import 'package:equatable/equatable.dart';
import 'package:spotify/domain/entities/song/song.dart';

abstract class AlbumDetailState extends Equatable {
  const AlbumDetailState();

  @override
  List<Object?> get props => [];
}

class AlbumDetailInitial extends AlbumDetailState {
  const AlbumDetailInitial();
}

class AlbumDetailLoading extends AlbumDetailState {
  const AlbumDetailLoading();
}

class AlbumDetailLoaded extends AlbumDetailState {
  final List<SongEntity> songs;

  const AlbumDetailLoaded(this.songs);

  @override
  List<Object?> get props => [songs];
}

class AlbumDetailError extends AlbumDetailState {
  final String message;

  const AlbumDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
