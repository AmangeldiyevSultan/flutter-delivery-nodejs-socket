import 'package:gooddelivary/features/account/services/account_services.dart';
import 'package:flutter/material.dart';
import 'package:gooddelivary/providers/locale_provider.dart';
import 'package:gooddelivary/providers/theme_provider.dart';
import 'package:gooddelivary/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../auth/screens/auth_screen.dart';
import 'account_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TopButtons extends StatelessWidget {
  const TopButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Column(
      children: [
        Row(
          children: [
            AccountButton(
              text: AppLocalizations.of(context)!.yourOrders,
              onTap: () {},
            ),
            AccountButton(
                text: userProvider.user.token.isEmpty
                    ? AppLocalizations.of(context)!.signin
                    : AppLocalizations.of(context)!.logout,
                onTap: () {
                  AccountServices().logOut(context);
                  Navigator.pushNamedAndRemoveUntil(
                      context, AuthScreen.routeName, (route) => false);
                }),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            AccountButton(
              text: AppLocalizations.of(context)!.resetLocale,
              onTap: () {
                final localProvider = context.read<LocaleProvider>();
                localProvider.resetLocale();
              },
            ),
            AccountButton(
              text: AppLocalizations.of(context)!.resetTheme,
              onTap: () {
                final themeProvider = context.read<ThemeProvider>();
                themeProvider.resetTheme();
              },
            ),
          ],
        )
      ],
    );
  }
}
