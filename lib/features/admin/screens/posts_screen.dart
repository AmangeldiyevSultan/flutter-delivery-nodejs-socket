import 'package:gooddelivary/common/widgets/loader.dart';
import 'package:gooddelivary/constants/enums.dart';
import 'package:gooddelivary/constants/global_variables.dart';
import 'package:gooddelivary/features/account/widgets/single_product.dart';
import 'package:gooddelivary/features/admin/screens/add_product_screen.dart';
import 'package:gooddelivary/features/admin/services/admin_services.dart';
import 'package:gooddelivary/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gooddelivary/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class PostsScreen extends StatefulWidget {
  static const String routeName = '/admin-post-screen';

  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Product>? products;
  AdminServices adminServices = AdminServices();
  @override
  void initState() {
    super.initState();
    _fetchAllProduct();
  }

  _fetchAllProduct() async {
    products = await adminServices.fetchAllProduct(context);
    setState(() {});
  }

  void _deleteProduct(Product product, int index) {
    adminServices.deleteProduct(
        context: context,
        product: product,
        onSuccess: () {
          products!.removeAt(index);
          setState(() {});
        });
  }

  void _navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  Future<void> _refresh(BuildContext context) {
    return Future.delayed(
      const Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? const Loader()
        : RefreshIndicator(
            onRefresh: () => _refresh(context),
            child: Scaffold(
              body: GridView.builder(
                  itemCount: products!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    final productData = products![index];
                    return Column(
                      children: [
                        SizedBox(
                          height: 140,
                          child: SingleProduct(
                            image: productData.images[0],
                            product: productData.name,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                child: Text(
                              productData.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            )),
                            IconButton(
                                onPressed: () =>
                                    _deleteProduct(productData, index),
                                icon: const Icon(Icons.delete_outline)),
                          ],
                        )
                      ],
                    );
                  }),
              floatingActionButton: floatingActionButton(context),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            ),
          );
  }

  FloatingActionButton floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor:
          context.watch<ThemeProvider>().themeType == ThemeType.dark
              ? GlobalVariables.darkButtonBackgroundCOlor
              : context.watch<ThemeProvider>().themeType == ThemeType.pink
                  ? GlobalVariables.pinkBackgroundColor
                  : null,
      onPressed: _navigateToAddProduct,
      tooltip: AppLocalizations.of(context)!.addProduct,
      child: Icon(
        Icons.add,
        color: context.watch<ThemeProvider>().themeType == ThemeType.pink
            ? Colors.white
            : null,
      ),
    );
  }
}
