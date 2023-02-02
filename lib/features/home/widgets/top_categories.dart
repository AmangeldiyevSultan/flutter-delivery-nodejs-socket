import 'package:flutter/material.dart';

import '../../../constants/global_variables.dart';
import '../screens/category_deals_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TopCategories extends StatelessWidget {
  const TopCategories({Key? key}) : super(key: key);

  void navigateToCategoryPage(BuildContext context, String category) {
    Navigator.pushNamed(context, CategoryDealsScreen.routeName,
        arguments: category);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        itemCount: GlobalVariables.categoryImages.length,
        scrollDirection: Axis.horizontal,
        itemExtent: 75,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => navigateToCategoryPage(
              context,
              GlobalVariables.categoryImages[index]['title']!,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      GlobalVariables.categoryImages[index]['image']!,
                      fit: BoxFit.cover,
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
                Text(
                  GlobalVariables.categoryImages[index]['title']! == 'Mobiles'
                      ? AppLocalizations.of(context)!.mobiles
                      : GlobalVariables.categoryImages[index]['title']! ==
                              'Essentials'
                          ? AppLocalizations.of(context)!.essentials
                          : GlobalVariables.categoryImages[index]['title']! ==
                                  'Appliances'
                              ? AppLocalizations.of(context)!.appliances
                              : GlobalVariables.categoryImages[index]
                                          ['title']! ==
                                      'Books'
                                  ? AppLocalizations.of(context)!.books
                                  : AppLocalizations.of(context)!.fashion,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
