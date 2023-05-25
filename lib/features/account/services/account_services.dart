import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../models/order.dart';
import '../../../providers/user_provider.dart';
import '../../auth/screens/auth_screen.dart';

class AccountServices {
  Future<List<Order>> fetchMyOrders({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/orders/me'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            orderList.add(
              Order.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return orderList;
  }

  void logOut(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      // ignore: use_build_context_synchronously
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await sharedPreferences.setString('x-auth-token', '').then((value) {
        userProvider.setUserFromModel(userProvider.user.copyWith(
            id: '',
            token: '',
            name: '',
            email: '',
            type: '',
            cart: [],
            password: '',
            address: '',
            FCMToken: ''));
        Navigator.pushNamedAndRemoveUntil(
          context,
          AuthScreen.routeName,
          (route) => false,
        );
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
