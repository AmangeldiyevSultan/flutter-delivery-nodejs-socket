import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gooddelivary/constants/enums.dart';
import 'package:gooddelivary/constants/error_handling.dart';
import 'package:gooddelivary/constants/global_variables.dart';
import 'package:gooddelivary/constants/utils.dart';
import 'package:gooddelivary/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProfileService {
  // sign chnage user
  void changeUserData({
    required BuildContext context,
    required UserTitleType userTitleType,
    required String title,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      http.Response response =
          await http.post(Uri.parse('$uri/api/changeUserData'),
              body: jsonEncode({
                'type': userTitleType.name,
                'title': title,
              }),
              headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          });
      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () async {
            // print(jsonDecode(response.body)['name']);
            if (userTitleType == UserTitleType.name) {
              userProvider.changedUser(userProvider.user
                  .copyWith(name: jsonDecode(response.body)['name']));
            }
            if (userTitleType == UserTitleType.email) {
              userProvider.changedUser(userProvider.user
                  .copyWith(email: jsonDecode(response.body)['email']));
            }
            if (userTitleType == UserTitleType.address) {
              userProvider.changedUser(userProvider.user
                  .copyWith(address: jsonDecode(response.body)['address']));
            }

            Navigator.pop(
                context, [showSnackBar(context, 'Succefully changed')]);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
