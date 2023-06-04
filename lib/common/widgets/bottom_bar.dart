import 'package:gooddelivary/constants/enums.dart';
import 'package:gooddelivary/constants/global_variables.dart';
import 'package:gooddelivary/features/account/screens/account_screen.dart';
import 'package:gooddelivary/features/cart/screens/cart_screen.dart';
import 'package:gooddelivary/features/home/screens/home_screen.dart';
import 'package:gooddelivary/features/profile/screen/profile_screen.dart';
import 'package:gooddelivary/providers/theme_provider.dart';
import 'package:gooddelivary/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badge;

class BottomBar extends StatefulWidget {
  static const String routeName = '/actual-home';
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const HomeScreen(),
    const AccountScreen(),
    const CartScreen(),
    const ProfileScreen()
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userCartLength = context.watch<UserProvider>().user.cart.length;
    final themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: _bottomNavigationBar(themeProvider, userCartLength),
    );
  }

  BottomNavigationBar _bottomNavigationBar(
      ThemeProvider themeProvider, int userCartLength) {
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
      onTap: updatePage,
      items: [
        //Home page
        _bottomNavigationBarItem(
            themeProvider, 0, userCartLength, Icons.shopping_cart_outlined),
        //account
        _bottomNavigationBarItem(
            themeProvider, 1, userCartLength, Icons.shopping_bag_outlined),
        //cart
        _bottomNavigationBarItem(
            themeProvider, 2, userCartLength, Icons.shopping_cart_outlined),

        //user profile
        _bottomNavigationBarItem(
            themeProvider, 3, userCartLength, Icons.account_box_outlined),
      ],
    );
  }

  BottomNavigationBarItem _bottomNavigationBarItem(ThemeProvider themeProvider,
      int page, int userCartLength, IconData iconData) {
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
            child: page == 2
                ? badge.Badge(
                    elevation: 0,
                    badgeContent: Text(
                      userCartLength.toString(),
                      style: TextStyle(
                          color: themeProvider.themeType == ThemeType.pink
                              ? Colors.white
                              : null),
                    ),
                    badgeColor: themeProvider.themeType == ThemeType.dark
                        ? GlobalVariables.darkGreyBackgroundCOlor
                        : themeProvider.themeType == ThemeType.pink
                            ? GlobalVariables.pinkGreyBackgroundCOlor
                            : Colors.white,
                    child: Icon(iconData))
                : Icon(iconData)));
  }
}
