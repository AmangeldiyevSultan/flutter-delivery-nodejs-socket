import 'dart:io';

import 'package:gooddelivary/common/widgets/custom_button.dart';
import 'package:gooddelivary/common/widgets/custom_textfield.dart';
import 'package:gooddelivary/constants/enums.dart';
import 'package:gooddelivary/constants/utils.dart';
import 'package:gooddelivary/features/admin/services/admin_services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gooddelivary/providers/location_provider.dart';
import 'package:gooddelivary/providers/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants/global_variables.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product';
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final AdminServices adminServices = AdminServices();
  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
  }

  late bool isLoading;
  String category = 'Mobiles';
  List<File> images = [];
  final _addProductFormKey = GlobalKey<FormState>();

  List<String> productCategories = [
    'Mobiles',
    'Essential',
    'Appliances',
    'Books',
    'Fashion',
  ];

  void _sellProduct() {
    if (_addProductFormKey.currentState!.validate() && images.isNotEmpty) {
      isLoading = true;
      setState(() {});
      adminServices
          .sellProduct(
              context: context,
              name: productNameController.text,
              description: descriptionController.text,
              price: double.parse(priceController.text),
              quantity: double.parse(quantityController.text),
              category: category,
              images: images)
          .then((value) {
        isLoading = false;
        setState(() {});
      });
    }
  }

  void _selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  @override
  void initState() {
    productCategories;
    category;
    isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
              leading: InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.black,
                ),
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: context.watch<ThemeProvider>().themeType ==
                            ThemeType.dark
                        ? GlobalVariables.darkAppBarGradient
                        : context.watch<ThemeProvider>().themeType ==
                                ThemeType.pink
                            ? GlobalVariables.pinkAppBarGradient
                            : GlobalVariables.appBarGradient),
              ),
              title: Text(
                AppLocalizations.of(context)!.addProduct,
                style: const TextStyle(color: Colors.black),
              ))),
      body: SingleChildScrollView(
          child: Form(
        key: _addProductFormKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Column(children: [
            const SizedBox(
              height: 20,
            ),
            images.isNotEmpty
                ? CarouselSlider(
                    items: images.map(
                      (i) {
                        return Builder(
                          builder: (BuildContext context) => Image.file(
                            i,
                            fit: BoxFit.cover,
                            height: 200,
                          ),
                        );
                      },
                    ).toList(),
                    options: CarouselOptions(
                      viewportFraction: 1,
                      height: 200,
                    ),
                  )
                : GestureDetector(
                    onTap: _selectImages,
                    child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        dashPattern: const [10, 4],
                        strokeCap: StrokeCap.round,
                        child: Container(
                          width: double.maxFinite,
                          height: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.folder_open,
                                  size: 40,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.selectProduct,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade400),
                                )
                              ]),
                        )),
                  ),
            const SizedBox(
              height: 30,
            ),
            CustomTextField(
                controller: productNameController,
                hintText: AppLocalizations.of(context)!.productName),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              controller: descriptionController,
              hintText: AppLocalizations.of(context)!.descriptionName,
              maxLines: 7,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
                controller: priceController,
                hintText: AppLocalizations.of(context)!.price),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
                controller: quantityController,
                hintText: AppLocalizations.of(context)!.quantity),
            SizedBox(
              width: double.maxFinite,
              child: DropdownButton(
                value: category,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: productCategories
                    .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item == 'Mobiles'
                              ? AppLocalizations.of(context)!.mobiles
                              : item == 'Essentials'
                                  ? AppLocalizations.of(context)!.essentials
                                  : item == 'Appliances'
                                      ? AppLocalizations.of(context)!.appliances
                                      : item == 'Books'
                                          ? AppLocalizations.of(context)!.books
                                          : AppLocalizations.of(context)!
                                              .fashion,
                        )))
                    .toList(),
                onChanged: (newVal) {
                  setState(() {
                    category = newVal!;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            isLoading
                ? ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : CustomButton(
                    text: AppLocalizations.of(context)!.sell,
                    onTap: _sellProduct)
          ]),
        ),
      )),
    );
  }
}
