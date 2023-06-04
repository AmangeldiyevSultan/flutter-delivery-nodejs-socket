import 'package:flutter/material.dart';
import 'package:gooddelivary/common/widgets/app_bar.dart';
import 'package:gooddelivary/constants/enums.dart';
import 'package:gooddelivary/features/profile/screen/profile_title_change.dart';
import 'package:gooddelivary/features/profile/widgets/profile_menu_widget.dart';
import 'package:gooddelivary/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  _navigateToProfileTitleChange(
      UserTitleType userTitleType, String title) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ProfileTitleChange(
              userTitleType: userTitleType,
              title: title,
            )));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: userProvider.user.type != 'admin'
          ? const PreferredSize(
              preferredSize: Size.fromHeight(60), child: AppBarWithOutSearch())
          : null,
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 40,
          ),
          Text(
            AppLocalizations.of(context)!.profile,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(
            height: 30,
          ),
          const SizedBox(height: 10),
          if (userProvider.user.token.isEmpty) ...[
            Container(
              width: double.maxFinite,
              alignment: Alignment.center,
              child: Text(
                AppLocalizations.of(context)!.youInGuestMode,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            )
          ] else ...[
            ProfileMenuWidget(
              titlePurpose: AppLocalizations.of(context)!.name,
              title: userProvider.user.name,
              icon: Icons.account_box_outlined,
              onPress: () {
                userProvider.user.password == 'google_sign'
                    ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            AppLocalizations.of(context)!.youCannotChangeName),
                        duration: const Duration(milliseconds: 500),
                      ))
                    : _navigateToProfileTitleChange(
                        UserTitleType.name, userProvider.user.name);
              },
            ),
            ProfileMenuWidget(
                titlePurpose: 'Email',
                title: userProvider.user.password == 'twitter_sign'
                    ? 'Twitter.com'
                    : userProvider.user.password == 'google_sign'
                        ? 'Google.com'
                        : userProvider.user.password == 'github_sign'
                            ? 'Github.com'
                            : userProvider.user.email,
                icon: Icons.email_outlined,
                onPress: () {
                  userProvider.user.password == 'twitter_sign'
                      ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              '${AppLocalizations.of(context)!.youSignInThrough} twitter!'),
                          duration: const Duration(milliseconds: 500),
                        ))
                      : userProvider.user.password == 'google_sign'
                          ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  '${AppLocalizations.of(context)!.youSignInThrough} google!'),
                              duration: const Duration(milliseconds: 500),
                            ))
                          : userProvider.user.password == 'github_sign'
                              ? ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  content: Text(
                                      '${AppLocalizations.of(context)!.youSignInThrough} github!'),
                                  duration: const Duration(milliseconds: 500),
                                ))
                              : _navigateToProfileTitleChange(
                                  UserTitleType.email, userProvider.user.email);
                }),
            ProfileMenuWidget(
                titlePurpose: AppLocalizations.of(context)!.address,
                title: userProvider.user.address,
                icon: Icons.place_outlined,
                onPress: () => _navigateToProfileTitleChange(
                    UserTitleType.address, userProvider.user.address)),
            ProfileMenuWidget(
                titlePurpose: AppLocalizations.of(context)!.role,
                title: userProvider.user.type == 'user'
                    ? AppLocalizations.of(context)!.user
                    : AppLocalizations.of(context)!.admin,
                icon: Icons.admin_panel_settings_outlined,
                onPress: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        AppLocalizations.of(context)!.youCanNotChangeYourRole),
                    duration: const Duration(milliseconds: 500),
                  ));
                })
          ],
        ]),
      ),
    );
  }
}
