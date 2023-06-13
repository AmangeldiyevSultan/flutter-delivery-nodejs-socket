import 'package:flutter/material.dart';
import 'package:gooddelivary/common/widgets/app_bar.dart';
import 'package:gooddelivary/features/order_details/screens/good_map.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/custom_button.dart';
import '../../../models/order.dart';
import '../../../providers/user_provider.dart';
import '../../admin/services/admin_services.dart';
import '../../search/screens/search_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderDetailScreen extends StatefulWidget {
  static const String routeName = '/order-details';
  final Order order;
  const OrderDetailScreen({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int currentStep = 0;
  final AdminServices adminServices = AdminServices();

  void _navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void _navigateToGoodMap(Order orderParams) {
    Navigator.pushNamed(context, GoodMap.routeName, arguments: orderParams);
  }

  @override
  void initState() {
    super.initState();
    currentStep = widget.order.status;
  }

  // !!! ONLY FOR ADMIN!!!
  void _changeOrderStatus(int status) {
    adminServices.changeOrderStatus(
      context: context,
      status: status + 1,
      order: widget.order,
      onSuccess: () {
        setState(() {
          adminServices.ordersStatusForAdmin(context);
          currentStep += 1;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child:
            AppBarWithSearch(navigateToSearchScreen: _navigateToSearchScreen),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.viewOrderDetails,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${AppLocalizations.of(context)!.orderdate}:      ${DateFormat().format(
                      DateTime.fromMillisecondsSinceEpoch(
                          widget.order.orderedAt),
                    )}'),
                    Text(
                        '${AppLocalizations.of(context)!.orderId}:          ${widget.order.id}'),
                    Text(
                        '${AppLocalizations.of(context)!.orderTotal}:      \$${widget.order.totalPrice}'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.purchaseDetails,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < widget.order.products.length; i++)
                      Row(
                        children: [
                          Image.network(
                            widget.order.products[i].images[0],
                            height: 120,
                            width: 120,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.order.products[i].name,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Qty: ${widget.order.quantity[i]}',
                                ),
                                Text(
                                  '${AppLocalizations.of(context)!.address}: ',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  widget.order.address.placeInfo!,
                                ),
                                Text(
                                  '${AppLocalizations.of(context)!.building}: ',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  widget.order.address.buidlingInfo!,
                                ),
                                Text(
                                  '${AppLocalizations.of(context)!.phonenum_pincode}: ',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${AppLocalizations.of(context)!.phoneNumber}: ${widget.order.address.phoneNumber!} \n${AppLocalizations.of(context)!.pinCode}:${widget.order.address.pincode}',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.tracking,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (currentStep == 1) ...[
                    GestureDetector(
                      onTap: () => _navigateToGoodMap(widget.order),
                      child: Text(AppLocalizations.of(context)!.showOnMap,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    )
                  ],
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                  ),
                ),
                child: Stepper(
                  currentStep: currentStep,
                  controlsBuilder: (context, details) {
                    if (user.type == 'admin') {
                      if (currentStep < 3) {
                        return CustomButton(
                          text: AppLocalizations.of(context)!.done,
                          onTap: () => _changeOrderStatus(details.currentStep),
                        );
                      }
                    }
                    return const SizedBox();
                  },
                  steps: [
                    Step(
                      title: Text(AppLocalizations.of(context)!.pending),
                      content: Text(
                        AppLocalizations.of(context)!
                            .yourOrderIsYetToBeDelivered,
                      ),
                      isActive: currentStep > 0,
                      state: currentStep > 0
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: Text(AppLocalizations.of(context)!.completed),
                      content: Text(
                        AppLocalizations.of(context)!.yourOrderHasBeenDelivered,
                      ),
                      isActive: currentStep > 1,
                      state: currentStep > 1
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: Text(AppLocalizations.of(context)!.recieved),
                      content: Text(
                        AppLocalizations.of(context)!
                            .yourOrderHasBeenDeliveredAndSignedByYou,
                      ),
                      isActive: currentStep > 2,
                      state: currentStep > 2
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: Text(AppLocalizations.of(context)!.delievered),
                      content: Text(
                        AppLocalizations.of(context)!
                            .yourOrderHasBeenDeliveredAndSignedByYou,
                      ),
                      isActive: currentStep >= 3,
                      state: currentStep >= 3
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
