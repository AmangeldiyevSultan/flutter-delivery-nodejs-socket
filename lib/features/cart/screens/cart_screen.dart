import 'package:flutter/material.dart';
import 'package:gooddelivary/common/widgets/app_bar.dart';
import 'package:gooddelivary/constants/enums.dart';
import 'package:gooddelivary/constants/utils.dart';
import 'package:gooddelivary/providers/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/custom_button.dart';
import '../../../constants/global_variables.dart';
import '../../../providers/user_provider.dart';
import '../../address/screens/address_screen.dart';
import '../../home/widgets/address_box.dart';
import '../../search/screens/search_screen.dart';
import '../widgets/cart_product.dart';
import '../widgets/cart_subtotal.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void _navigateToAddress(int sum) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user.token.isEmpty) {
      showSnackBar(context, AppLocalizations.of(context)!.pleaseSignIn);
    } else {
      Navigator.pushNamed(
        context,
        AddressScreen.routeName,
        arguments: sum.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final themeProvider = context.watch<ThemeProvider>();
    int sum = 0;
    user.cart
        .map((e) => sum += e['quantity'] * e['product']['price'] as int)
        .toList();

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBarWithSearch(
              navigateToSearchScreen: _navigateToSearchScreen)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AddressBox(),
            const CartSubtotal(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                text:
                    '${AppLocalizations.of(context)!.proceedToBuy} (${user.cart.length})',
                onTap: () => _navigateToAddress(sum),
                color: themeProvider.themeType == ThemeType.dark
                    ? const Color.fromARGB(255, 90, 83, 102)
                    : themeProvider.themeType == ThemeType.pink
                        ? GlobalVariables.pinkSecondaryColor
                        : Colors.yellow[600],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              color: Colors.black12.withOpacity(0.08),
              height: 1,
            ),
            const SizedBox(height: 5),
            ListView.builder(
              itemCount: user.cart.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return CartProduct(
                  index: index,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
