import 'package:flutter/material.dart';
import 'package:gooddelivary/constants/enums.dart';
import 'package:gooddelivary/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class SingleProduct extends StatelessWidget {
  final String image;
  final String product;
  const SingleProduct({
    Key? key,
    required this.image,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black12,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(5),
          color: context.watch<ThemeProvider>().themeType == ThemeType.dark
              ? Colors.black26
              : Colors.white,
        ),
        child: Stack(
          children: [
            Container(
              width: 180,
              padding: const EdgeInsets.all(10),
              child: Image.network(
                image,
                fit: BoxFit.fitHeight,
                width: 180,
              ),
            ),
            Text(product),
          ],
        ),
      ),
    );
  }
}
