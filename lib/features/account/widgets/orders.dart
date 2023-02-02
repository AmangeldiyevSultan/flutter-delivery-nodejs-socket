import 'package:amazon_clone/features/account/widgets/single_product.dart';
import 'package:flutter/material.dart';

import '../../../constants/global_variables.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List list = [
    'https://images-eu.ssl-images-amazon.com/images/G/31/img21/Wireless/WLA/TS/D37847648_Accessories_savingdays_Jan22_Cat_PC_1500.jpg',
    'https://images-eu.ssl-images-amazon.com/images/G/31/img21/Wireless/WLA/TS/D37847648_Accessories_savingdays_Jan22_Cat_PC_1500.jpg',
    'https://images-eu.ssl-images-amazon.com/images/G/31/img21/Wireless/WLA/TS/D37847648_Accessories_savingdays_Jan22_Cat_PC_1500.jpg',
    'https://images-eu.ssl-images-amazon.com/images/G/31/img21/Wireless/WLA/TS/D37847648_Accessories_savingdays_Jan22_Cat_PC_1500.jpg',
  ];

  // List<Order>? orders;
  // final AccountServices accountServices = AccountServices();

  @override
  void initState() {
    super.initState();
    // fetchOrders();
  }

  // void fetchOrders() async {
  //   orders = await accountServices.fetchMyOrders(context: context);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return
        //  orders == null
        // ? const Loader()
        // :
        Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 15,
              ),
              child: Text(
                AppLocalizations.of(context)!.yourOrders,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                right: 15,
              ),
              child: Text(
                AppLocalizations.of(context)!.seeAll,
                style: TextStyle(
                  color: GlobalVariables.selectedNavBarColor,
                ),
              ),
            ),
          ],
        ),
        // display orders
        Container(
          height: 170,
          padding: const EdgeInsets.only(
            left: 10,
            top: 20,
            right: 0,
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            itemBuilder: ((context, index) {
              return SingleProduct(
                image: list[index],
              );
            }),
          ),
          // child: ListView.builder(
          //   scrollDirection: Axis.horizontal,
          //   itemCount: orders!.length,
          //   itemBuilder: (context, index) {
          //     return GestureDetector(
          //       onTap: () {
          //         Navigator.pushNamed(
          //           context,
          //           OrderDetailScreen.routeName,
          //           arguments: orders![index],
          //         );
          //       },
          //       child: SingleProduct(
          //         image: orders![index].products[0].images[0],
          //       ),
          //     );
          //   },
          // ),
        ),
      ],
    );
  }
}
