import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/global_variables.dart';
import '../../../l10n/l10n.dart';
import '../../../providers/locale_provider.dart';
import '../../../providers/user_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BelowAppBar extends StatelessWidget {
  const BelowAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    final locale = provider.locale;
    return Container(
      decoration: const BoxDecoration(
        gradient: GlobalVariables.appBarGradient,
      ),
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
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
                  final provider =
                      Provider.of<LocaleProvider>(context, listen: false);
                  provider.setLocale(locale);
                },
              );
            }).toList(),
            onChanged: (_) {},
          )),
        ],
      ),
    );
  }
}
