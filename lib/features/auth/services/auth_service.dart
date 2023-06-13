// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:github_sign_in_plus/github_sign_in_plus.dart';
import 'package:gooddelivary/common/widgets/bottom_bar.dart';
import 'package:gooddelivary/constants/error_handling.dart';
import 'package:gooddelivary/constants/global_variables.dart';
import 'package:gooddelivary/constants/utils.dart';
import 'package:gooddelivary/features/admin/screens/admin_screen.dart';
import 'package:gooddelivary/models/user.dart';
import 'package:gooddelivary/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twitter_login/entity/auth_result.dart';

class AuthService {
  // sign up user

  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required String typeUser,
  }) async {
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      User user = User(
          id: '',
          email: email,
          name: name,
          password: password,
          address: '',
          FCMToken: fcmToken ?? '',
          token: '',
          type: typeUser,
          cart: []);
      http.Response response = await http.post(Uri.parse('$uri/api/signup'),
          body: user.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });
      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(
                context, 'Account created! Login with same credentials');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //github sign in
  void githubSignInUser({
    required BuildContext context,
    required GitHubSignInResult gitHubSignInResult,
  }) async {
    try {
      http.Response tokenRes = await http.get(
          Uri.parse('https://api.github.com/user'),
          headers: <String, String>{
            'Authorization': 'Bearer ${gitHubSignInResult.token}'
          });
      String gitId = '';
      String gitLogin = '';
      if (tokenRes.statusCode == 200) {
        gitId = json.decode(tokenRes.body)['id'].toString();
        gitLogin = json.decode(tokenRes.body)['login'].toString();
      } else {
        return showSnackBar(context, 'Please retry!');
      }
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      User user = User(
          id: '',
          email: '$gitId@github.com',
          name: gitLogin,
          password: '',
          address: '',
          type: '',
          FCMToken: fcmToken ?? '',
          token: '',
          cart: []);
      http.Response response = await http.post(
          Uri.parse('$uri/api/githubsignup'),
          body: user.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });
      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            Provider.of<UserProvider>(context, listen: false)
                .setUser(response.body);
            await prefs.setString(
                "x-auth-token", jsonDecode(response.body)['token']);
            jsonDecode(response.body)['type'] == 'user'
                ? Navigator.pushNamedAndRemoveUntil(
                    context, BottomBar.routeName, (route) => false)
                : Navigator.pushNamedAndRemoveUntil(
                    context, AdminScreen.routeName, (route) => false);
            showSnackBar(context, 'Account sign in!');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //twitter sign in
  void twitterSignInUser({
    required BuildContext context,
    required AuthResult twitterUserAccount,
  }) async {
    try {
      final twitterUser = twitterUserAccount.user;

      String? fcmToken = await FirebaseMessaging.instance.getToken();
      User user = User(
          id: '',
          email: '${twitterUser!.id}@twitter.com',
          name: twitterUser.name,
          password: '',
          address: '',
          type: '',
          FCMToken: fcmToken ?? '',
          token: '',
          cart: []);
      http.Response response = await http.post(
          Uri.parse('$uri/api/twittersignup'),
          body: user.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });
      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            Provider.of<UserProvider>(context, listen: false)
                .setUser(response.body);
            await prefs.setString(
                "x-auth-token", jsonDecode(response.body)['token']);
            jsonDecode(response.body)['type'] == 'user'
                ? Navigator.pushNamedAndRemoveUntil(
                    context, BottomBar.routeName, (route) => false)
                : Navigator.pushNamedAndRemoveUntil(
                    context, AdminScreen.routeName, (route) => false);
            showSnackBar(context, 'Account sign in!');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //google sign in
  void googleSignInUser({
    required BuildContext context,
    required GoogleSignInAccount googleUserAccount,
  }) async {
    try {
      final userAuth = await googleUserAccount.authentication;
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      User user = User(
          id: '',
          email: googleUserAccount.email,
          name: googleUserAccount.displayName ?? '',
          password: userAuth.accessToken!,
          address: '',
          type: '',
          FCMToken: fcmToken ?? '',
          token: '',
          cart: []);
      http.Response response = await http.post(
          Uri.parse('$uri/api/googlesignup'),
          body: user.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });
      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            Provider.of<UserProvider>(context, listen: false)
                .setUser(response.body);
            await prefs.setString(
                "x-auth-token", jsonDecode(response.body)['token']);
            jsonDecode(response.body)['type'] == 'user'
                ? Navigator.pushNamedAndRemoveUntil(
                    context, BottomBar.routeName, (route) => false)
                : Navigator.pushNamedAndRemoveUntil(
                    context, AdminScreen.routeName, (route) => false);
            showSnackBar(context, 'Account sign in!');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // sign in user
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      http.Response response = await http.post(Uri.parse('$uri/api/signin'),
          body: jsonEncode({
            'email': email,
            'password': password,
            'fcmToken': fcmToken ?? ''
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });
      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            Provider.of<UserProvider>(context, listen: false)
                .setUser(response.body);
            await prefs.setString(
                "x-auth-token", jsonDecode(response.body)['token']);
            jsonDecode(response.body)['type'] == 'user'
                ? Navigator.pushNamedAndRemoveUntil(
                    context, BottomBar.routeName, (route) => false)
                : Navigator.pushNamedAndRemoveUntil(
                    context, AdminScreen.routeName, (route) => false);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // get user data
  void getUserData({
    required BuildContext context,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      // ignore: avoid_print
      print(token);
      if (token == null) {
        prefs.setString('x-auth-token', '');
      }
      var tokenRes = await http
          .post(Uri.parse('$uri/tokenIsValid'), headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8',
        'x-auth-token': token!,
      });

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/'),
          headers: <String, String>{
            'Content-type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
