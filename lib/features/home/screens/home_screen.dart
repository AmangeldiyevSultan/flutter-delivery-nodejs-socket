import 'package:gooddelivary/common/widgets/app_bar.dart';
import 'package:gooddelivary/features/home/widgets/address_box.dart';
import 'package:gooddelivary/features/home/widgets/carousel_image.dart';
import 'package:gooddelivary/features/home/widgets/deal_of_day.dart';
import 'package:gooddelivary/features/home/widgets/top_categories.dart';
import 'package:gooddelivary/features/search/screens/search_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child:
            AppBarWithSearch(navigateToSearchScreen: _navigateToSearchScreen),
      ),
      body: const SingleChildScrollView(
        child: Column(children: [
          AddressBox(),
          SizedBox(
            height: 10,
          ),
          TopCategories(),
          SizedBox(
            height: 10,
          ),
          CarouselImage(),
          SizedBox(
            height: 10,
          ),
          DealOfDay(),
        ]),
      ),
    );
  }
}
