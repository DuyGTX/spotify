import 'package:spotify/domain/entities/song/song.dart';

abstract class TrendingSongState {}


class TrendingSongLoading extends TrendingSongState{}

class TrendingSongLoaded extends TrendingSongState{

  final List<SongEntity> songs;
  TrendingSongLoaded({required this.songs});
}    
class TrendingSongLoadFailure extends TrendingSongState{}