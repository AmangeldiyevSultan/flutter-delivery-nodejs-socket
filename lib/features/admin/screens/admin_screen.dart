import 'package:amazon_clone/features/admin/screens/posts_screen.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../constants/global_variables.dart';
import '../../../l10n/l10n.dart';
import '../../../providers/locale_provider.dart';
import '../../auth/screens/auth_screen.dart';
import '../../auth/services/auth_service.dart';

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
    const Center(child: Text('Analytics Page')),
    const Center(child: Text('Cart Page')),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    final locale = provider.locale;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            flexibleSpace: Container(
              decoration:
                  const BoxDecoration(gradient: GlobalVariables.appBarGradient),
            ),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      AuthService().logOut(context);
                      Navigator.pushNamedAndRemoveUntil(
                          context, AuthScreen.routeName, (route) => false);
                    },
                    child: Container(
                        child: Center(
                      child: Text(AppLocalizations.of(context)!.logout),
                    )),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                      'assets/images/amazon_in.png',
                      height: 45,
                      width: 120,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.admin,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  DropdownButtonHideUnderline(
                      child: DropdownButton(
                    value: locale,
                    icon: Container(width: 12),
                    items: L10n.all.map((locale) {
                      final flag = L10n.getFlag(locale.languageCode);
                      return DropdownMenuItem(
                        child: Center(
                          child: Text(
                            flag,
                            style: TextStyle(fontSize: 28),
                          ),
                        ),
                        value: locale,
                        onTap: () {
                          final provider = Provider.of<LocaleProvider>(context,
                              listen: false);
                          provider.setLocale(locale);
                        },
                      );
                    }).toList(),
                    onChanged: (_) {},
                  )),
                ]),
          )),
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: updatePage,
        items: [
          //Home page
          BottomNavigationBarItem(
              label: '',
              icon: Container(
                  width: bottomBarWidth,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                          color: _page == 0
                              ? GlobalVariables.selectedNavBarColor
                              : GlobalVariables.backgroundColor,
                          width: bottomBarBorderWidth),
                    ),
                  ),
                  child: const Icon(Icons.home_outlined))),
          //analytics
          BottomNavigationBarItem(
              label: '',
              icon: Container(
                  width: bottomBarWidth,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                          color: _page == 1
                              ? GlobalVariables.selectedNavBarColor
                              : GlobalVariables.backgroundColor,
                          width: bottomBarBorderWidth),
                    ),
                  ),
                  child: const Icon(Icons.analytics_outlined))),
          //inbox
          BottomNavigationBarItem(
              label: '',
              icon: Container(
                  width: bottomBarWidth,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                          color: _page == 2
                              ? GlobalVariables.selectedNavBarColor
                              : GlobalVariables.backgroundColor,
                          width: bottomBarBorderWidth),
                    ),
                  ),
                  child: const Icon(Icons.all_inbox_outlined))),
          //cart
        ],
      ),
    );
  }
}
