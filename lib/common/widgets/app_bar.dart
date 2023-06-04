import 'package:flutter/material.dart';
import 'package:gooddelivary/common/widgets/locale_widget.dart';
import 'package:gooddelivary/common/widgets/theme_widget.dart';
import 'package:gooddelivary/constants/enums.dart';
import 'package:gooddelivary/constants/global_variables.dart';
import 'package:gooddelivary/features/account/services/account_services.dart';
import 'package:gooddelivary/features/admin/services/admin_services.dart';
import 'package:gooddelivary/features/auth/screens/auth_screen.dart';
import 'package:gooddelivary/providers/locale_provider.dart';
import 'package:gooddelivary/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppBarWithOutSearch extends StatelessWidget {
  const AppBarWithOutSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: themeProvider.themeType == ThemeType.dark
              ? GlobalVariables.darkAppBarGradient
              : themeProvider.themeType == ThemeType.pink
                  ? GlobalVariables.pinkAppBarGradient
                  : GlobalVariables.appBarGradient,
        ),
      ),
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                height: 42,
                child: const Text(
                  'GoodDelivery',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 15),
                child: Icon(Icons.notifications_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AppBarWithSearch extends StatelessWidget {
  final Function(String) navigateToSearchScreen;
  const AppBarWithSearch({super.key, required this.navigateToSearchScreen});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: themeProvider.themeType == ThemeType.dark
              ? GlobalVariables.darkAppBarGradient
              : themeProvider.themeType == ThemeType.pink
                  ? GlobalVariables.pinkAppBarGradient
                  : GlobalVariables.appBarGradient,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              height: 42,
              margin: const EdgeInsets.only(left: 15),
              child: Material(
                borderRadius: BorderRadius.circular(7),
                elevation: 1,
                child: TextFormField(
                  onFieldSubmitted: (query) => navigateToSearchScreen(query),
                  decoration: InputDecoration(
                    prefixIcon: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 6,
                        ),
                        child: Icon(
                          Icons.search,
                          color: themeProvider.themeType == ThemeType.dark
                              ? Colors.white
                              : Colors.black,
                          size: 23,
                        ),
                      ),
                    ),
                    filled: true,
                    fillColor: themeProvider.themeType == ThemeType.dark
                        ? Colors.black12
                        : Colors.white,
                    contentPadding: const EdgeInsets.only(top: 10),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(7),
                      ),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(7),
                      ),
                      borderSide: BorderSide(
                        color: Colors.black38,
                        width: 1,
                      ),
                    ),
                    hintText:
                        '${AppLocalizations.of(context)!.search} GoodDelivary',
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.transparent,
            height: 42,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.mic,
                color: themeProvider.themeType == ThemeType.dark
                    ? Colors.white
                    : Colors.black,
                size: 25),
          ),
        ],
      ),
    );
  }
}

class AdminAppBar extends StatelessWidget {
  AdminAppBar({super.key});

  final AdminServices _adminServices = AdminServices();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    final themeProvider = context.watch<ThemeProvider>();
    final locale = provider.locale;

    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: themeProvider.themeType == ThemeType.dark
                ? GlobalVariables.darkAppBarGradient
                : themeProvider.themeType == ThemeType.pink
                    ? GlobalVariables.pinkAppBarGradient
                    : GlobalVariables.appBarGradient),
      ),
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        InkWell(
          onTap: () {
            _adminServices.stopListeningToLocationUpdates(context);
            AccountServices().logOut(context);
            Navigator.pushNamedAndRemoveUntil(
                context, AuthScreen.routeName, (route) => false);
          },
          child: Center(
            child: Text(AppLocalizations.of(context)!.logout),
          ),
        ),
        const Text('GoodDelivary'),
        Row(
          children: [
            const ThemeChoiceDropDown(),
            LocaleChoiseDropDown(locale: locale),
          ],
        ),
      ]),
    );
  }
}
