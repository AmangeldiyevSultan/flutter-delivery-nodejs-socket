// ignore_for_file: prefer_const_constructors

import 'package:gooddelivary/common/widgets/bottom_bar.dart';
import 'package:gooddelivary/common/widgets/custom_button.dart';
import 'package:gooddelivary/common/widgets/custom_textfield.dart';
import 'package:gooddelivary/constants/global_variables.dart';
import 'package:gooddelivary/constants/utils.dart';
import 'package:gooddelivary/features/auth/services/auth_service.dart';
import 'package:gooddelivary/l10n/l10n.dart';
import 'package:gooddelivary/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  void googleSignInUser(GoogleSignInAccount googleUserAccount) {
    authService.googleSignInUser(
        context: context, googleUserAccount: googleUserAccount);
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
                      value: locale,
                      onTap: () {
                        final provider =
                            Provider.of<LocaleProvider>(context, listen: false);
                        provider.setLocale(locale);
                      },
                      child: Center(
                        child: Text(
                          flag,
                          style: TextStyle(fontSize: 32),
                        ),
                      ),
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
            if (_auth == Auth.signup) ...[
              Container(
                padding: EdgeInsets.all(8),
                color: GlobalVariables.backgroundColor,
                child: Column(
                  children: [
                    Form(
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
                            }),
                      ]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            color: GlobalVariables.selectedNavBarColor,
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                                child: Text('Google Sign In',
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () async {
                                  GoogleSignIn googleSignIn = GoogleSignIn();
                                  final user = await googleSignIn.signIn();
                                  if (user != null) {
                                    googleSignInUser(user);
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    showSnackBar(context, 'Unexpected error!');
                                  }
                                })),
                        Container(
                            color: GlobalVariables.selectedNavBarColor,
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                                child: Text(
                                  'Guest Mode',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, BottomBar.routeName);
                                })),
                      ],
                    )
                  ],
                ),
              ),
            ],
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
                        }),
                  ]),
                ),
              ),
          ],
        ),
      )),
    );
  }
}
