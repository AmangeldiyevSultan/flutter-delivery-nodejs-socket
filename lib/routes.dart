import 'package:gooddelivary/common/widgets/bottom_bar.dart';
import 'package:gooddelivary/features/address/screens/address_screen.dart';
import 'package:gooddelivary/features/admin/screens/add_product_screen.dart';
import 'package:gooddelivary/features/admin/screens/admin_screen.dart';
import 'package:gooddelivary/features/home/screens/category_deals_screen.dart';
import 'package:gooddelivary/features/home/screens/home_screen.dart';
import 'package:gooddelivary/features/auth/screens/auth_screen.dart';
import 'package:gooddelivary/features/order_details/screens/order_detail.dart';
import 'package:gooddelivary/features/product_details/screens/product_detail_screen.dart';
import 'package:gooddelivary/features/search/screens/search_screen.dart';
import 'package:gooddelivary/features/order_details/screens/good_map.dart';
import 'package:flutter/material.dart';

import 'models/order.dart';
import 'models/product.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    case ProductDetailScreen.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ProductDetailScreen(
          product: product,
        ),
      );
    case AdminScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AdminScreen(),
      );
    case SearchScreen.routeName:
      var searchQuery = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SearchScreen(
          searchQuery: searchQuery,
        ),
      );
    case CategoryDealsScreen.routeName:
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CategoryDealsScreen(
          category: category,
        ),
      );
    case AddProductScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddProductScreen(),
      );
    case AddressScreen.routeName:
      var totalAmount = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddressScreen(
          totalAmount: totalAmount,
        ),
      );
    case OrderDetailScreen.routeName:
      var order = routeSettings.arguments as Order;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OrderDetailScreen(
          order: order,
        ),
      );
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(),
      );
    case GoodMap.routeName:
      var orderParams = routeSettings.arguments as Order;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => GoodMap(
          orderParams: orderParams,
        ),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text("Screen does not exist!"),
          ),
        ),
      );
  }
}
