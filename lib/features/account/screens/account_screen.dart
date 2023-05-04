import 'package:gooddelivary/constants/global_variables.dart';
import 'package:gooddelivary/features/account/widgets/below_app_bar.dart';
import 'package:gooddelivary/features/account/widgets/orders.dart';
import 'package:gooddelivary/features/account/widgets/top_buttons.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: const [
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
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            flexibleSpace: Container(
              decoration:
                  const BoxDecoration(gradient: GlobalVariables.appBarGradient),
            ),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('GoodDelivary'),
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: Icon(Icons.notifications_outlined),
                        ),
                        // Padding(
                        // padding: EdgeInsets.only(right: 15),
                        // child:
                        Icon(Icons.search),
                        // )
                      ],
                    ),
                  )
                ]),
          )),
    );
  }
}
