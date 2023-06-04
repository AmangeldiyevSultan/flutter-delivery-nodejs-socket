// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:gooddelivary/constants/enums.dart';
import 'package:gooddelivary/constants/utils.dart';
import 'package:gooddelivary/constants/global_variables.dart';
import 'package:gooddelivary/features/profile/service/profile_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gooddelivary/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ProfileTitleChange extends StatefulWidget {
  final UserTitleType userTitleType;
  final String title;
  const ProfileTitleChange(
      {Key? key, required this.userTitleType, required this.title})
      : super(key: key);

  @override
  State<ProfileTitleChange> createState() => _ProfileTitleChangeState();
}

class _ProfileTitleChangeState extends State<ProfileTitleChange> {
  TextEditingController? _userTitleContoller;

  @override
  void initState() {
    super.initState();
    _userTitleContoller = TextEditingController(text: widget.title);
  }

  final ProfileService _profileService = ProfileService();
  final _changeUserDataFormKey = GlobalKey<FormState>();

  _setChange() {
    _profileService.changeUserData(
        context: context,
        userTitleType: widget.userTitleType,
        title: _userTitleContoller!.text);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
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
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Form(
              key: _changeUserDataFormKey,
              child: TextFormField(
                validator: (val) {
                  if (widget.userTitleType == UserTitleType.email) {
                    bool isEmailValid = isValidEmail(val!);
                    if (isEmailValid) {
                      return null;
                    } else {
                      return AppLocalizations.of(context)!.checkYourEmail;
                    }
                  }
                  return null;
                },
                controller: _userTitleContoller,
              ),
            ),
            OutlinedButton(
                style: ButtonStyle(
                    backgroundColor: context.watch<ThemeProvider>().themeType ==
                            ThemeType.dark
                        ? const MaterialStatePropertyAll(
                            GlobalVariables.darkButtonBackgroundCOlor)
                        : null),
                onPressed: () {
                  if (_changeUserDataFormKey.currentState!.validate()) {
                    _setChange();
                  }
                },
                child: Text(
                  AppLocalizations.of(context)!.confirm,
                  style: TextStyle(
                      color: context.watch<ThemeProvider>().themeType ==
                              ThemeType.dark
                          ? Colors.white
                          : null),
                ))
          ],
        ),
      ),
    );
  }
}
