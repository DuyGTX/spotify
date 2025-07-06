import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:diacritic/diacritic.dart';

class SearchService {
  final SupabaseClient client = Supabase.instance.client;

  // Nghệ sĩ
  Future<List<Map<String, dynamic>>> searchArtists(String query) async {
    final data = await client
        .from('Artists')
        .select('id, name, avatar_image')
        .limit(20);
    // Lọc gần đúng không dấu
    final processedQuery = removeDiacritics(query).toLowerCase();
    return List<Map<String, dynamic>>.from(data)
        .where((item) =>
            removeDiacritics(item['name'] ?? '')
                .toLowerCase()
                .contains(processedQuery))
        .toList();
  }

  // Bài hát
  Future<List<Map<String, dynamic>>> searchSongs(String query) async {
  final data = await client
    .from('Songs')
    .select('''
      id, song_name, duration, release_date, genre, song_url, cover_image, lyrics, lyrics_lrc, artist_id, album_id, Artists(name)
    ''')
    .limit(30);

  final processedQuery = removeDiacritics(query).toLowerCase();
  return List<Map<String, dynamic>>.from(data)
      .where((item) =>
          removeDiacritics(item['song_name'] ?? '')
              .toLowerCase()
              .contains(processedQuery))
      .toList();
}


  // Album
  Future<List<Map<String, dynamic>>> searchAlbums(String query) async {
    final data = await client
        .from('Albums')
        .select('id, album_name, album_cover, artist_id')
        .limit(30);
    final processedQuery = removeDiacritics(query).toLowerCase();
    return List<Map<String, dynamic>>.from(data)
        .where((item) =>
            removeDiacritics(item['album_name'] ?? '')
                .toLowerCase()
                .contains(processedQuery))
        .toList();
  }

  // Gợi ý nghệ sĩ (có thể lấy random/top nghệ sĩ)
  Future<List<Map<String, dynamic>>> suggestArtists([int limit = 5]) async {
    final data = await client
        .from('Artists')
        .select('id, name, avatar_image')
        .limit(limit);
    return List<Map<String, dynamic>>.from(data);
  }
  Future<List<Map<String, dynamic>>> getSongsByArtistId(int artistId) async {
  final data = await client
      .from('Songs')
      .select('id, song_name, song_url, cover_image, duration, release_date, genre, lyrics, lyrics_lrc, artist_id, album_id, Artists(name)')
      .eq('artist_id', artistId)
      .limit(20);

  return List<Map<String, dynamic>>.from(data);
}



}
