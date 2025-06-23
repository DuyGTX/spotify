import 'package:flutter/material.dart';

class TestTabBarPage extends StatefulWidget {
  const TestTabBarPage({super.key});

  @override
  State<TestTabBarPage> createState() => _TestTabBarPageState();
}

class _TestTabBarPageState extends State<TestTabBarPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        tabBarTheme: const TabBarTheme(
          dividerColor: Colors.transparent, // CHÌA KHÓA ở Flutter 3.29.3!
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.transparent, width: 0),
          ),
          overlayColor: MaterialStatePropertyAll(Colors.transparent),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text("Test TabBar", style: TextStyle(color: Colors.black)),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(child: Text('Nổi Bật')),
              Tab(child: Text('Nhạc')),
              Tab(child: Text('Albums')),
              Tab(child: Text('Podcasts')),
            ],
            // Không cần set indicator/dividerColor ở đây nữa!
            splashFactory: NoSplash.splashFactory,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            Center(child: Text("Tab 1")),
            Center(child: Text("Tab 2")),
            Center(child: Text("Tab 3")),
            Center(child: Text("Tab 4")),
          ],
        ),
      ),
    );
  }
}
