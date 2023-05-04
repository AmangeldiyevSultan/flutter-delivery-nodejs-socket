import 'package:gooddelivary/common/widgets/loader.dart';
import 'package:gooddelivary/features/account/widgets/single_product.dart';
import 'package:gooddelivary/features/admin/screens/add_product_screen.dart';
import 'package:gooddelivary/features/admin/services/admin_services.dart';
import 'package:gooddelivary/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    fetchAllProduct();
  }

  fetchAllProduct() async {
    products = await adminServices.fetchAllProduct(context);
    setState(() {});
  }

  void deleteProduct(Product product, int index) {
    adminServices.deleteProduct(
        context: context,
        product: product,
        onSuccess: () {
          products!.removeAt(index);
          setState(() {});
        });
  }

  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  Future<void> _refresh(BuildContext context) {
    // setState(() {
    //   final productProvider =
    //       Provider.of<ProductProvider>(context, listen: true);
    //   productProvider.update();
    // });
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
                                    deleteProduct(productData, index),
                                icon: const Icon(Icons.delete_outline)),
                          ],
                        )
                      ],
                    );
                  }),
              floatingActionButton: FloatingActionButton(
                onPressed: navigateToAddProduct,
                tooltip: AppLocalizations.of(context)!.addProduct,
                child: const Icon(Icons.add),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            ),
          );
  }
}
