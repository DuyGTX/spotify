import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/core/configs/assets/app_images.dart';
import 'package:spotify/core/configs/assets/app_vectors.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/presentation/dashboard/custom_bottom_nav_bar.dart';
import 'package:spotify/presentation/home/widgets/outstanding_song.dart';
import 'package:spotify/presentation/home/widgets/trending_song.dart';
import 'package:spotify/presentation/song_player/pages/mini_player_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedBottomIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedBottomIndex = index;
    });
    // TODO: Sau này chuyển sang các trang khác theo index
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: context.isDarkMode ? Colors.black : Colors.white,
        appBar: BasicAppbar(
          hideBack: true,
          title: Image.asset(
            AppImages.logo,
            height: 40,
            width: 150,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _homeTopCard(),
            _tabs(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _tabAll(),
                  _tabMusic(),
                  _tabAlbums(),
                  _tabPodcasts(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    const MiniPlayerView(),
    AppBottomNavigationBar(
      currentIndex: _selectedBottomIndex,
      onTap: _onBottomNavTap,
    ),
  ],
),

      ),
    );
  }

  Widget _homeTopCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 140,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset(AppVectors.homeTopCard),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Image.asset(AppImages.homeArtist),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabs() {
    return Theme(
      data: Theme.of(context).copyWith(
        tabBarTheme: TabBarTheme(
          dividerColor: Colors.transparent,
          indicatorColor: AppColors.primary,
          labelColor: context.isDarkMode ? Colors.white : Colors.black,
          unselectedLabelColor: Colors.grey,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(child: Text('Tất Cả', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16))),
          Tab(child: Text('Nhạc', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16))),
          Tab(child: Text('Albums', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16))),
          Tab(child: Text('Podcasts', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16))),
        ],
      ),
    );
  }

  // Tab "Tất Cả"
  Widget _tabAll() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Được đề xuất cho hôm nay',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
            ),
          ),
          Outstanding(),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              'Bài hát thịnh hành',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
            ),
          ),
          TrendingSong(),
          SizedBox(height: 32),
        ],
      ),
    );
  }

  // Tab "Nhạc"
  Widget _tabMusic() {
    return const Center(child: Text('Nội dung Nhạc'));
  }

  // Tab "Albums"
  Widget _tabAlbums() {
    return const Center(child: Text('Nội dung Albums'));
  }

  // Tab "Podcasts"
  Widget _tabPodcasts() {
    return const Center(child: Text('Nội dung Podcasts'));
  }
}
