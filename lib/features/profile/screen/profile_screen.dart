import 'package:flutter/material.dart';
import 'package:gooddelivary/constants/enums.dart';
import 'package:gooddelivary/constants/global_variables.dart';
import 'package:gooddelivary/features/profile/screen/profile_title_change.dart';
import 'package:gooddelivary/features/profile/widgets/profile_menu_widget.dart';
import 'package:gooddelivary/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  navigateToProfileTitleChange(
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
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
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 40,
          ),
          Text(
            'Profile',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(
            height: 30,
          ),
          Stack(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset('assets/images/profile_image.png')),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (userProvider.user.token.isEmpty) ...[
            Container(
              width: double.maxFinite,
              alignment: Alignment.center,
              child: Text(
                'You in Guest Mode',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            )
          ] else ...[
            ProfileMenuWidget(
                titlePurpose: 'Name',
                title: userProvider.user.name,
                icon: Icons.account_box_outlined,
                onPress: () => navigateToProfileTitleChange(
                    UserTitleType.name, userProvider.user.name)),
            ProfileMenuWidget(
                titlePurpose: 'Email',
                title: userProvider.user.email,
                icon: Icons.email_outlined,
                onPress: () => navigateToProfileTitleChange(
                    UserTitleType.email, userProvider.user.email)),
            ProfileMenuWidget(
                titlePurpose: 'Address',
                title: userProvider.user.address,
                icon: Icons.place_outlined,
                onPress: () => navigateToProfileTitleChange(
                    UserTitleType.address, userProvider.user.address)),
            ProfileMenuWidget(
                titlePurpose: 'Role',
                title: userProvider.user.type,
                icon: Icons.admin_panel_settings_outlined,
                onPress: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('You can not change your role!'),
                    duration: Duration(milliseconds: 500),
                  ));
                })
          ],
        ]),
      ),
    );
  }
}
