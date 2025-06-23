import 'package:dartz/dartz.dart';
import 'package:spotify/data/sources/songs/song_supabase_service.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/repository/song/song.dart';

import '../../../service_locator.dart';

class SongRepositoryImpl extends SongRepository {
  @override
  Future<Either<Exception, List<SongEntity>>> getOutstandingSongs() {
    return sl<SongSupaBaseService>().getOutstandingSongs();
  }


  @override
  Future<Either<Exception, List<SongEntity>>> getTrendingSongs() {
    return sl<SongSupaBaseService>().getTrendingSongs();
  }
}
