import 'package:gooddelivary/features/account/services/account_services.dart';
import 'package:gooddelivary/features/account/widgets/single_product.dart';
import 'package:flutter/material.dart';
import 'package:gooddelivary/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/loader.dart';
import '../../../constants/global_variables.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/order.dart';
import '../../order_details/screens/order_detail.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Order>? orders;
  final AccountServices accountServices = AccountServices();

  @override
  void initState() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    super.initState();
    if (userProvider.user.token.isNotEmpty) {
      fetchOrders();
    }
  }

  void fetchOrders() async {
    orders = await accountServices.fetchMyOrders(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return userProvider.user.token.isEmpty
        ? Column(
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
                        color: GlobalVariables.lightSelectedNavBarColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        : orders == null
            ? const Loader()
            : Column(
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
                            color: GlobalVariables.lightSelectedNavBarColor,
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
                      itemCount: orders!.length,
                      itemBuilder: ((context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              OrderDetailScreen.routeName,
                              arguments: orders![index],
                            );
                          },
                          child: SingleProduct(
                            image: orders![index].products[0].images[0],
                            product: orders![index].products[0].name,
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              );
  }
}
