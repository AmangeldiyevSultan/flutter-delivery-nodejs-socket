import 'package:flutter/material.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.titlePurpose,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String titlePurpose;
  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    var iconColor = Colors.black;

    return ListTile(
      subtitle: Text(titlePurpose),
      onTap: onPress,
      leading: SizedBox(
        width: 40,
        height: 40,
        child: Icon(
          icon,
          color: iconColor,
          size: 30,
        ),
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context).textTheme.bodyLarge?.apply(
                  color: textColor,
                  fontSizeDelta: 1,
                  overflow: TextOverflow.ellipsis)),
        ],
      ),
      trailing: endIcon
          ? const SizedBox(
              width: 30,
              height: 30,
              child: Icon(
                Icons.navigate_next_outlined,
                size: 30.0,
                color: Colors.grey,
              ))
          : null,
    );
  }
}
