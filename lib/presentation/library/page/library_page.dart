import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/presentation/favorite/bloc/favorite_song_cubit.dart';
import 'package:spotify/presentation/favorite/bloc/favorite_song_state.dart';
import 'package:spotify/presentation/favorite/page/favorite_song_page.dart';
import 'package:spotify/presentation/setting/page/setting.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<FavoriteSongCubit>().getFavoriteSongs();
    final isDark = context.isDarkMode;
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color secondaryTextColor = isDark ? Colors.grey[400]! : Colors.grey[800]!;
    final Color iconColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: BasicAppbar(
        title: Text(
          'Thư viện',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textColor),
        ),
        action: Padding(
            padding: const EdgeInsets.only(right: 12), // Đẩy icon sang trái
            child: IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Cài đặt',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
            ),
          ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Filter buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  FilterChip(
                    label: Text('Danh sách phát', style: TextStyle(color: textColor)),
                    selected: true,
                    onSelected: (selected) {},
                    backgroundColor: isDark ? Colors.grey[800] : Colors.grey[300],
                    selectedColor: isDark ? Colors.grey[700] : Colors.grey[500],
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: Text('Nghệ sĩ', style: TextStyle(color: textColor)),
                    selected: false,
                    onSelected: (selected) {},
                    backgroundColor: isDark ? Colors.grey[800] : Colors.grey[300],
                    selectedColor: isDark ? Colors.grey[700] : Colors.grey[500],
                  ),
                ],
              ),
            ),
            // Sort and grid view options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.swap_vert, color: iconColor, size: 20),
                  const SizedBox(width: 8),
                  Text('Gần đây', style: TextStyle(color: textColor, fontSize: 14)),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.grid_view, color: iconColor),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            // Favorite songs section
            BlocBuilder<FavoriteSongCubit, FavoriteSongState>(
              builder: (context, state) {
                int count = 0;
                if (state is FavoriteSongListLoaded) {
                  count = state.songs.length;
                }
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FavoriteSongsPage(),
                        ),
                      ).then((_) {
                        context.read<FavoriteSongCubit>().getFavoriteSongs();
                      });
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bài hát đã thích',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.push_pin,
                                    color: AppColors.primary,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Danh sách phát • $count bài hát',
                                    style: TextStyle(
                                      color: secondaryTextColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.more_vert,
                          color: secondaryTextColor,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Add to playlist button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.add,
                        color: textColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Thêm vào danh sách phát này',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
