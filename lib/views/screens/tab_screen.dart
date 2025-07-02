import 'package:build_clock/viewmodels/tab_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'font_clock_screen.dart';
import 'canvas_clock_screen.dart';
import 'world_clock_screen.dart';
import 'background_selector_screen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Widget> _screens = [
    const FontClockScreen(),
    const CanvasClockScreen(),
    const WorldClockScreen(),
    const BackgroundSelectorScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _screens.length,
      vsync: this,
      initialIndex: 0,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TabViewModel()..initialize(),
      child: Consumer<TabViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.grey[900]?.withValues(alpha: 0.95),
              elevation: 2,
              toolbarHeight: 0,
              bottom: TabBar(
                controller: _tabController,
                labelColor: Colors.green,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.green,
                indicatorWeight: 3,
                tabs: const [
                  Tab(icon: Icon(Icons.text_fields), text: 'Font Clock'),
                  Tab(icon: Icon(Icons.brush), text: 'Canvas Clock'),
                  Tab(icon: Icon(Icons.public), text: 'World Clock'),
                  Tab(icon: Icon(Icons.wallpaper), text: 'Background'),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: _screens,
            ),
          );
        },
      ),
    );
  }
}
