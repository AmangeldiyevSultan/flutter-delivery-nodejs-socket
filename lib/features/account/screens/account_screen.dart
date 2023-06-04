import 'package:gooddelivary/common/widgets/app_bar.dart';
import 'package:gooddelivary/features/account/widgets/below_app_bar.dart';
import 'package:gooddelivary/features/account/widgets/orders.dart';
import 'package:gooddelivary/features/account/widgets/top_buttons.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Column(children: [
          BelowAppBar(),
          SizedBox(
            height: 10,
          ),
          TopButtons(),
          SizedBox(
            height: 20,
          ),
          Orders(),
        ]),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(60), child: AppBarWithOutSearch()));
  }
}
