// ignore_for_file: prefer_const_constructors

import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/custom_textfield.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/auth/services/auth_service.dart';
import 'package:amazon_clone/l10n/l10n.dart';
import 'package:amazon_clone/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

enum Auth { signin, signup }

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.signup;
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();

  final AuthService authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  void signUpUser() {
    authService.signUpUser(
        context: context,
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text);
  }

  void signInUser() {
    authService.signInUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    final locale = provider.locale;
    return Scaffold(
      appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.welcome,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButtonHideUnderline(
                    child: DropdownButton(
                  value: locale,
                  icon: Container(width: 12),
                  items: L10n.all.map((locale) {
                    final flag = L10n.getFlag(locale.languageCode);
                    return DropdownMenuItem(
                      child: Center(
                        child: Text(
                          flag,
                          style: TextStyle(fontSize: 32),
                        ),
                      ),
                      value: locale,
                      onTap: () {
                        final provider =
                            Provider.of<LocaleProvider>(context, listen: false);
                        provider.setLocale(locale);
                      },
                    );
                  }).toList(),
                  onChanged: (_) {},
                )),
              ],
            ),
          ]),
      backgroundColor: GlobalVariables.greyBackgroundCOlor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            ListTile(
              tileColor: _auth == Auth.signup
                  ? GlobalVariables.backgroundColor
                  : Colors.transparent,
              title: Text(
                AppLocalizations.of(context)!.createAccount,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Radio(
                activeColor: GlobalVariables.secondaryColor,
                value: Auth.signup,
                groupValue: _auth,
                onChanged: (Auth? val) {
                  setState(() {
                    _auth = val!;
                  });
                },
              ),
            ),
            if (_auth == Auth.signup)
              Container(
                padding: EdgeInsets.all(8),
                color: GlobalVariables.backgroundColor,
                child: Form(
                  key: _signUpFormKey,
                  child: Column(children: [
                    CustomTextField(
                      controller: _nameController,
                      hintText: AppLocalizations.of(context)!.name,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: _emailController,
                      hintText: "Email",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: AppLocalizations.of(context)!.password,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                        text: AppLocalizations.of(context)!.signup,
                        onTap: () {
                          if (_signUpFormKey.currentState!.validate()) {
                            signUpUser();
                          }
                        })
                  ]),
                ),
              ),
            ListTile(
              tileColor: _auth == Auth.signin
                  ? GlobalVariables.backgroundColor
                  : Colors.transparent,
              title: Text(
                AppLocalizations.of(context)!.signin,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Radio(
                activeColor: GlobalVariables.secondaryColor,
                value: Auth.signin,
                groupValue: _auth,
                onChanged: (Auth? val) {
                  setState(() {
                    _auth = val!;
                  });
                },
              ),
            ),
            if (_auth == Auth.signin)
              Container(
                padding: EdgeInsets.all(8),
                color: GlobalVariables.backgroundColor,
                child: Form(
                  key: _signInFormKey,
                  child: Column(children: [
                    CustomTextField(
                      controller: _emailController,
                      hintText: "Email",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: AppLocalizations.of(context)!.password,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                        text: AppLocalizations.of(context)!.signin,
                        onTap: () {
                          signInUser();
                        })
                  ]),
                ),
              ),
          ],
        ),
      )),
    );
  }
}
