import 'package:flutter/material.dart';
import 'package:gooddelivary/constants/enums.dart';
import 'package:gooddelivary/constants/global_variables.dart';
import 'package:gooddelivary/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemeChoiceDropDown extends StatelessWidget {
  const ThemeChoiceDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return DropdownButtonHideUnderline(
        child: DropdownButton(
      dropdownColor: themeProvider.themeType == ThemeType.pink
          ? GlobalVariables.pinkSecondaryColor
          : themeProvider.themeType == ThemeType.light
              ? GlobalVariables.lightSelectedNavBarColor
              : null,
      icon: Container(width: 12),
      value: themeProvider.themeType.name,
      hint: const Text('theme'),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      items: [
        DropdownMenuItem(
          value: 'dark',
          onTap: () {
            themeProvider.themeType = ThemeType.dark;
          },
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.dark,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
        DropdownMenuItem(
          value: 'light',
          onTap: () {
            themeProvider.themeType = ThemeType.light;
          },
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.light,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
        DropdownMenuItem(
          value: 'pink',
          onTap: () {
            themeProvider.themeType = ThemeType.pink;
          },
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.pink,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ],
      onChanged: (_) {},
    ));
  }
}
