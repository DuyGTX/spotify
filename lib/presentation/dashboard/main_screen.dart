import 'package:flutter/material.dart';
import 'package:spotify/presentation/dashboard/custom_bottom_nav_bar.dart';
import 'package:spotify/presentation/home/pages/home.dart';
import 'package:spotify/presentation/library/page/library_page.dart';
import 'package:spotify/presentation/profile/profile_page.dart';
import 'package:spotify/presentation/search/pages/search_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const LibraryPage(),
    const ProfilePage(),
  ];



  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );

  }
}
