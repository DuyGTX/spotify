  import 'package:dartz/dartz.dart';
  import 'package:spotify/data/models/song/song.dart';
  import 'package:spotify/domain/entities/song/song.dart';
  import 'package:supabase_flutter/supabase_flutter.dart';

  abstract class SongSupaBaseService {
    Future<Either<Exception, List<SongEntity>>> getOutstandingSongs();
    Future<Either<Exception, List<SongEntity>>> getTrendingSongs();
  }

  class SongSupaBaseServiceImpl extends SongSupaBaseService {
    final SupabaseClient client = Supabase.instance.client;

    @override
    Future<Either<Exception, List<SongEntity>>> getOutstandingSongs() async {
      try {
        final response = await client
            .from('Songs')
            .select()
            .order('release_date', ascending: false)
            .limit(9);

        // Ép kiểu rõ ràng
        final List<dynamic> rawList = response;
        final songs = rawList
            .map((item) => SongModel.fromJson(item as Map<String, dynamic>).toEntity())
            .toList();

        print("Fetched songs: ${songs.length}");

        return Right(songs);
      } catch (e, stackTrace) {
        print("Supabase error: $e");
        print(stackTrace);
        return Left(Exception('Failed to fetch songs: $e'));
      }
    }

    
    Future<Either<Exception, List<SongEntity>>> getTrendingSongs() async {
    try {
      final response = await client
          .from('Songs')
          .select()
          .eq('trending', true) // 🔥 Lọc bài thịnh hành
          .order('release_date', ascending: false)
          .limit(9); // tuỳ chỉnh số lượng

      final List<dynamic> rawList = response;
      final songs = rawList
          .map((item) => SongModel.fromJson(item as Map<String, dynamic>).toEntity())
          .toList();

      return Right(songs);
    } catch (e) {
      return Left(Exception('Lỗi lấy bài thịnh hành: $e'));
    }
  }

  }

