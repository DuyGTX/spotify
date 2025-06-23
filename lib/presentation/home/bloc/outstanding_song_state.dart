import 'package:spotify/domain/entities/song/song.dart';

abstract class OutstandingSongState {}


class OutstandingSongLoading extends OutstandingSongState{}

class OutstandingSongLoaded extends OutstandingSongState{

  final List<SongEntity> songs;
  OutstandingSongLoaded({required this.songs});
}    
class OutstandingSongLoadFailure extends OutstandingSongState{}