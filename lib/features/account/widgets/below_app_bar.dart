import 'package:flutter/material.dart';
import 'package:gooddelivary/common/widgets/locale_widget.dart';
import 'package:gooddelivary/common/widgets/theme_widget.dart';
import 'package:gooddelivary/constants/enums.dart';
import 'package:gooddelivary/providers/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants/global_variables.dart';
import '../../../providers/locale_provider.dart';
import '../../../providers/user_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BelowAppBar extends StatelessWidget {
  const BelowAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final locale = provider.locale;
    return Container(
      decoration: BoxDecoration(
        gradient: themeProvider.themeType == ThemeType.dark
            ? GlobalVariables.darkAppBarGradient
            : themeProvider.themeType == ThemeType.pink
                ? GlobalVariables.pinkAppBarGradient
                : GlobalVariables.appBarGradient,
      ),
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                text: '${AppLocalizations.of(context)!.hello}, ',
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: user.name,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              const ThemeChoiceDropDown(),
              LocaleChoiseDropDown(locale: locale),
            ],
          ),
        ],
      ),
    );
  }
}
