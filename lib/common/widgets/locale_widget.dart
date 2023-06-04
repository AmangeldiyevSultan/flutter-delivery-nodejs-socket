import 'package:flutter/material.dart';
import 'package:gooddelivary/l10n/l10n.dart';
import 'package:gooddelivary/providers/locale_provider.dart';
import 'package:provider/provider.dart';

class LocaleChoiseDropDown extends StatelessWidget {
  final Locale locale;
  const LocaleChoiseDropDown({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
        child: DropdownButton(
      value: locale,
      icon: Container(width: 12),
      items: L10n.all.map((locale) {
        final flag = L10n.getFlag(locale.languageCode);
        return DropdownMenuItem(
          value: locale,
          onTap: () {
            final provider =
                Provider.of<LocaleProvider>(context, listen: false);
            provider.setLocale(locale);
          },
          child: Center(
            child: Text(
              flag,
              style: const TextStyle(fontSize: 28),
            ),
          ),
        );
      }).toList(),
      onChanged: (_) {},
    ));
  }
}
