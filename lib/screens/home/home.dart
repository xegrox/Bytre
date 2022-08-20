import 'package:bytre/styles.dart';
import 'package:bytre/widgets/tabler_icon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'pages/page_info_mixin.dart';
import 'pages/plugins/plugins.dart';
import 'pages/projects/projects.dart';
import 'pages/sdk_manager/sdk_manager.dart';
import 'pages/storages/storages.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Iterable<Widget> _tabFabLabels;
  late Iterable<Function(BuildContext, TabController)> _tabFabActions;
  
  final List<PageInfoMixin> _tabPages = [
    const StoragesPage(),
    const ProjectsPage(),
    const PluginsPage(),
    const SDKManagerPage()
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 1, length: _tabPages.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
    _tabFabLabels = _tabPages.map((p) => Text(p.fabLabel, maxLines: 1, key: Key(p.fabLabel)));
    _tabFabActions = _tabPages.map((p) => p.fabAction);
  }

  Widget _pageWithTitle(PageInfoMixin page) => Scaffold(
    appBar: AppBar(
      titleSpacing: 25,
      title: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Text(
          page.title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 22
          )
        )
      ),
      toolbarHeight: 80,
      centerTitle: false,
    ),
    body: page,
  );

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Container(
      color: theme.background,
      child: SafeArea(
        child: Scaffold(
          body: TabBarView(
            controller: _tabController,
            children: _tabPages.map((e) => _pageWithTitle(e)).toList(),
            physics: const NeverScrollableScrollPhysics(),
          ),
          bottomNavigationBar: Container(
            color: theme.background,
            child: SalomonBottomBar(
              currentIndex: _tabController.index,
              onTap: (i) => _tabController.animateTo(i),
              selectedItemColor: Theme
                  .of(context)
                  .bottomNavigationBarTheme
                  .selectedItemColor,
              unselectedItemColor: Theme
                  .of(context)
                  .bottomNavigationBarTheme
                  .unselectedItemColor,
              items: [
                SalomonBottomBarItem(
                    icon: TablerIcon(TablerIcons.database),
                    title: const Text('Storages'),
                    selectedColor: theme.bottomNavSelectedFS),
                SalomonBottomBarItem(
                    icon: TablerIcon(TablerIcons.layout_list),
                    title: const Text('Projects'),
                    selectedColor: theme.bottomNavSelectedProj),
                SalomonBottomBarItem(
                    icon: TablerIcon(TablerIcons.plug),
                    title: const Text('Plugins'),
                    selectedColor: theme.bottomNavSelectedPlug),
                SalomonBottomBarItem(
                    icon: TablerIcon(TablerIcons.threed_cube_sphere),
                    title: const Text('SDK Manager'),
                    selectedColor: theme.bottomNavSelectedSDK)
              ]
            )
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          floatingActionButton: Builder(
            builder: (context) => FloatingActionButton.extended(
              onPressed: () => _tabFabActions.elementAt(_tabController.index)(context, _tabController),
              icon: TablerIcon(TablerIcons.plus),
              label: AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: _tabFabLabels.elementAt(_tabController.index)
              )
            )
          )
        )
      )
    );
  }
}