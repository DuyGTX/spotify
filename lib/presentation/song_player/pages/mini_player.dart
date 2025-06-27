// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:spotify/core/configs/theme/app_colors.dart';
// import 'package:spotify/domain/entities/song/song.dart';
// import 'package:spotify/presentation/song_player/bloc/song_player_cubit.dart';
// import 'package:spotify/presentation/song_player/bloc/song_player_state.dart';
// import 'package:spotify/presentation/song_player/pages/song_player.dart';

// class MiniPlayerWidget extends StatelessWidget {
//   const MiniPlayerWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SongPlayerCubit, SongPlayerState>(
//       builder: (context, state) {
//         final cubit = context.read<SongPlayerCubit>();

//         // Không hiển thị nếu không có bài hát nào đang phát
//         if (cubit.currentSong.songName.isEmpty) {
//           return const SizedBox.shrink();
//         }

//         final song = cubit.currentSong;
//         final isPlaying = cubit.audioPlayer.playing;

//         return SafeArea(
//           child: GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => SongPlayerPage(
//                     songEntity: song,
//                     allSongs: cubit.allSongs,
//                     currentIndex: cubit.currentIndex,
//                   ),
//                 ),
//               );
//             },
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.grey[900],
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 5,
//                     offset: Offset(0, 2),
//                   )
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   // Ảnh bài hát
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Image.network(
//                       song.coverImage,
//                       width: 48,
//                       height: 48,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   const SizedBox(width: 12),

//                   // Tên bài hát và nghệ sĩ
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           song.songName,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           song.artist,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(color: Colors.grey, fontSize: 12),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Nút Play/Pause
//                   IconButton(
//                     onPressed: () => cubit.playOrPauseSong(),
//                     icon: AnimatedSwitcher(
//                       duration: const Duration(milliseconds: 300),
//                       transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
//                       child: Icon(
//                         isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
//                         key: ValueKey<bool>(isPlaying),
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
