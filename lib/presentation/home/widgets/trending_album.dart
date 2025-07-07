import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/usecases/song/get_trending_album.dart';
import 'package:spotify/presentation/album/page/album_detail.dart';
import 'package:spotify/presentation/home/bloc/trending_album_cubit.dart';
import 'package:spotify/presentation/home/bloc/trending_album_state.dart';
import 'package:spotify/service_locator.dart';


class TrendingAlbum extends StatelessWidget {
  const TrendingAlbum({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TrendingAlbumCubit(sl<GetTrendingAlbumsUseCase>())..fetchTrendingAlbums(),
      child: BlocBuilder<TrendingAlbumCubit, TrendingAlbumState>(
        builder: (context, state) {
          if (state is TrendingAlbumLoading) {
            return Center(child: CircularProgressIndicator(color: AppColors.primary,));
          } else if (state is TrendingAlbumLoaded) {
            return _buildAlbumList(context, state.albums);
          } else if (state is TrendingAlbumError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildAlbumList(BuildContext context, List<AlbumEntity> albums) {
    return SizedBox(
      height: 250,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: albums.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final album = albums[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AlbumDetailPage(album: album),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    album.albumCover,
                    width: 160,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 160,
                  child: Text(
                    album.albumName,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 160,
                  child: Text(
                    album.artistName,
                    style: const TextStyle(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
