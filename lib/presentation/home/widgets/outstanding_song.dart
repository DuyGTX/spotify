import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';
import 'package:spotify/core/configs/assets/app_vectors.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/usecases/song/get_outstrading_song.dart';
import 'package:spotify/presentation/home/bloc/outstanding_song_cubit.dart';
import 'package:spotify/presentation/home/bloc/outstanding_song_state.dart';

import 'package:spotify/presentation/song_player/pages/song_player.dart';
import 'package:spotify/service_locator.dart';

class Outstanding extends StatelessWidget {
  const Outstanding({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: BlocProvider(
        create: (_) => OutstandingSongCubit(sl<GetOutstradingSongUseCase>())..getOutstandingSongs(),
        child: BlocBuilder<OutstandingSongCubit, OutstandingSongState>(
          builder: (context, state) {
            if (state is OutstandingSongLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            }
            if (state is OutstandingSongLoaded) {
              return _songs(context, state.songs);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _songs(BuildContext context, List<SongEntity> songs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 270,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: songs.length,
          separatorBuilder: (context, index) => const SizedBox(width: 14),
          itemBuilder: (context, index) {
            final song = songs[index];
            return GestureDetector(
              onTap: () {
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SongPlayerPage(
                      songEntity: song,
                      allSongs: songs,
                      currentIndex: index,
                    ),
                  ),
                );

              },
              child: SizedBox(
                width: 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 190,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(song.coverImage),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          height: 40,
                          width: 40,
                          transform: Matrix4.translationValues(10, 10, 0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.isDarkMode
                                ? AppColors.darkGrey
                                : const Color(0xffE6E6E6),
                          ),
                          child: SvgPicture.asset(
                            AppVectors.play,
                            fit: BoxFit.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      song.songName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      song.artistName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
