import 'package:gooddelivary/features/account/services/account_services.dart';
import 'package:flutter/material.dart';

import '../../auth/screens/auth_screen.dart';
import 'account_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TopButtons extends StatelessWidget {
  const TopButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButton(
              text: AppLocalizations.of(context)!.yourOrders,
              onTap: () {},
            ),
            AccountButton(
                text: AppLocalizations.of(context)!.logout,
                onTap: () {
                  AccountServices().logOut(context);
                  Navigator.pushNamedAndRemoveUntil(
                      context, AuthScreen.routeName, (route) => false);
                }
                // AccountServices().logOut(context),
                ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
