import 'package:amazon_clone/models/product.dart';
import 'package:flutter/cupertino.dart';

class ProductProvider extends ChangeNotifier {
  Product _product = Product(
      name: '',
      description: '',
      quantity: 0.0,
      images: [],
      category: '',
      price: 0.0);

  Product get product => _product;

  void setUser(String product) {
    _product = Product.fromJson(product);
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }
}
