import 'package:gooddelivary/common/widgets/app_bar.dart';
import 'package:gooddelivary/common/widgets/locale_widget.dart';
import 'package:gooddelivary/common/widgets/theme_widget.dart';
import 'package:gooddelivary/constants/enums.dart';
import 'package:gooddelivary/features/admin/screens/analytics_screen.dart';
import 'package:gooddelivary/features/admin/screens/order_screen.dart';
import 'package:gooddelivary/features/admin/screens/posts_screen.dart';
import 'package:flutter/material.dart';
import 'package:gooddelivary/features/profile/screen/profile_screen.dart';
import 'package:gooddelivary/providers/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants/global_variables.dart';

class AdminScreen extends StatefulWidget {
  static const String routeName = '/admin-screen';
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const PostsScreen(),
    const AnalyticsScreen(),
    const OrdersScreen(),
    const ProfileScreen()
  ];

  void _updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50), child: AdminAppBar()),
      body: pages[_page],
      bottomNavigationBar: _bottomNavigationBar(themeProvider),
    );
  }

  BottomNavigationBar _bottomNavigationBar(ThemeProvider themeProvider) {
    return BottomNavigationBar(
      currentIndex: _page,
      selectedItemColor: themeProvider.themeType == ThemeType.dark
          ? GlobalVariables().darkSelectedNavBarColor
          : themeProvider.themeType == ThemeType.pink
              ? GlobalVariables.pinkGreyBackgroundCOlor
              : GlobalVariables.lightSelectedNavBarColor,
      unselectedItemColor: themeProvider.themeType == ThemeType.dark
          ? Colors.white38
          : themeProvider.themeType == ThemeType.pink
              ? GlobalVariables.pinkBackgroundColor
              : GlobalVariables.lightUnselectedNavBarColor,
      backgroundColor: GlobalVariables.lightBackgroundColor,
      iconSize: 28,
      onTap: _updatePage,
      items: [
        //Home page
        _bottomNavigationBarItem(themeProvider, 0, Icons.home_outlined),
        //analytics
        _bottomNavigationBarItem(themeProvider, 1, Icons.analytics_outlined),
        //inbox
        _bottomNavigationBarItem(themeProvider, 2, Icons.all_inbox_outlined),
        //user profile
        _bottomNavigationBarItem(themeProvider, 3, Icons.account_box_outlined),
      ],
    );
  }

  BottomNavigationBarItem _bottomNavigationBarItem(
      ThemeProvider themeProvider, int page, IconData iconData) {
    return BottomNavigationBarItem(
        label: '',
        icon: Container(
            width: bottomBarWidth,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                    color: _page == page
                        ? themeProvider.themeType == ThemeType.dark
                            ? GlobalVariables().darkSelectedNavBarColor
                            : themeProvider.themeType == ThemeType.pink
                                ? GlobalVariables.pinkGreyBackgroundCOlor
                                : GlobalVariables.lightSelectedNavBarColor
                        : Colors.transparent,
                    width: bottomBarBorderWidth),
              ),
            ),
            child: Icon(iconData)));
  }
}
