// ignore_for_file: prefer_const_constructors

import 'package:github_sign_in_plus/github_sign_in_plus.dart';
import 'package:gooddelivary/common/widgets/bottom_bar.dart';
import 'package:gooddelivary/common/widgets/custom_button.dart';
import 'package:gooddelivary/common/widgets/custom_textfield.dart';
import 'package:gooddelivary/common/widgets/locale_widget.dart';
import 'package:gooddelivary/common/widgets/theme_widget.dart';
import 'package:gooddelivary/constants/enums.dart';
import 'package:gooddelivary/constants/global_variables.dart';
import 'package:gooddelivary/constants/utils.dart';
import 'package:gooddelivary/features/auth/services/auth_service.dart';
import 'package:gooddelivary/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gooddelivary/providers/theme_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:github_signin_promax/github_signin_promax.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthType _auth = AuthType.signup;
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  String typeUser = 'user';

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

  void _signUpUser() {
    authService.signUpUser(
        context: context,
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
        typeUser: typeUser);
  }

  void _signInUser() {
    authService.signInUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  void _googleSignInUser(GoogleSignInAccount googleUserAccount) {
    authService.googleSignInUser(
        context: context, googleUserAccount: googleUserAccount);
  }

  void _twitterSignInUser(AuthResult authResult) {
    authService.twitterSignInUser(
        context: context, twitterUserAccount: authResult);
  }

  void _githubSignInUser(GitHubSignInResult gitHubSignInResult) {
    authService.githubSignInUser(
        context: context, gitHubSignInResult: gitHubSignInResult);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final locale = provider.locale;
    return Scaffold(
      appBar: _appBar(context, locale),
      backgroundColor: themeProvider.themeType == ThemeType.dark
          ? GlobalVariables.darkGreyBackgroundCOlor
          : GlobalVariables.lightGreyBackgroundCOlor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              _chooseAuthType(themeProvider, context,
                  AppLocalizations.of(context)!.createAccount, AuthType.signup),
              if (_auth == AuthType.signup) _authSignUp(themeProvider, context),
              _chooseAuthType(themeProvider, context,
                  AppLocalizations.of(context)!.createAccount, AuthType.signin),
              if (_auth == AuthType.signin) _authSignIn(themeProvider, context),
            ],
          ),
        ),
      )),
    );
  }

  AppBar _appBar(BuildContext context, Locale locale) {
    return AppBar(
        title: Text(
          AppLocalizations.of(context)!.welcome,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ThemeChoiceDropDown(),
              LocaleChoiseDropDown(locale: locale),
            ],
          ),
        ]);
  }

  ListTile _chooseAuthType(ThemeProvider themeProvider, BuildContext context,
      String text, AuthType authType) {
    return ListTile(
      tileColor: themeProvider.themeType == ThemeType.dark
          ? _auth == authType
              ? GlobalVariables.darkBackgroundColor
              : Colors.transparent
          : _auth == authType
              ? GlobalVariables.lightBackgroundColor
              : Colors.transparent,
      title: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      leading: Radio(
        value: authType,
        groupValue: _auth,
        onChanged: (AuthType? val) {
          setState(() {
            _auth = val!;
          });
        },
      ),
    );
  }

  Container _authSignIn(ThemeProvider themeProvider, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      color: themeProvider.themeType == ThemeType.dark
          ? GlobalVariables.darkBackgroundColor
          : GlobalVariables.lightBackgroundColor,
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
                _signInUser();
              }),
        ]),
      ),
    );
  }

  Container _authSignUp(ThemeProvider themeProvider, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      color: themeProvider.themeType == ThemeType.dark
          ? GlobalVariables.darkBackgroundColor
          : GlobalVariables.lightBackgroundColor,
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
                      _signUpUser();
                    }
                  }),
            ]),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 300,
            height: 50,
            child: DropdownButton(
                hint: Text(typeUser == 'user'
                    ? AppLocalizations.of(context)!.user
                    : AppLocalizations.of(context)!.admin),
                items: [
                  DropdownMenuItem(
                    value: 'admin',
                    child: Text(AppLocalizations.of(context)!.admin),
                  ),
                  DropdownMenuItem(
                    value: 'user',
                    child: Text(AppLocalizations.of(context)!.user),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    typeUser = value!;
                  });
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                    color: themeProvider.themeType == ThemeType.pink
                        ? GlobalVariables.pinkSecondaryColor
                        : GlobalVariables.lightSelectedNavBarColor,
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        child: Text(AppLocalizations.of(context)!.googleSignIn,
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        onPressed: () async {
                          GoogleSignIn googleSignIn = GoogleSignIn();
                          final user = await googleSignIn.signIn();
                          if (user != null) {
                            _googleSignInUser(user);
                          } else {
                            // ignore: use_build_context_synchronously
                            showSnackBar(context, 'Unexpected error!');
                          }
                        })),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Container(
                    color: themeProvider.themeType == ThemeType.pink
                        ? GlobalVariables.pinkSecondaryColor
                        : GlobalVariables.lightSelectedNavBarColor,
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        child: Text(AppLocalizations.of(context)!.twitterSignIn,
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          final twitterLogin = TwitterLogin(
                              apiKey: 'YU34BCF1x7ZhaYSeWnqSRiJsS',
                              apiSecretKey:
                                  'eMudAHYU2QEGIzbCWtggdh8vzhhJ5CAW6JF3tlqXcaNtz3g4Fx',
                              redirectURI: 'flutter-twitter-practice://');
                          await twitterLogin.login().then((authResult) async {
                            _twitterSignInUser(authResult);
                          });
                        })),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Container(
                    color: themeProvider.themeType == ThemeType.pink
                        ? GlobalVariables.pinkSecondaryColor
                        : GlobalVariables.lightSelectedNavBarColor,
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        child: Text(AppLocalizations.of(context)!.githubSignIn,
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          final GitHubSignIn gitHubSignIn = GitHubSignIn(
                              clientId: '0ed3fc51bb9bb97638f8',
                              clientSecret:
                                  '6c8d7e837b2c7ec2eb96d2c585838c0c0a253708',
                              redirectUrl:
                                  'https://push-notification-gooddelivery.firebaseapp.com/__/auth/handler');
                          var result = await gitHubSignIn.signIn(context);
                          var params = GithubSignInParams(
                              clientId: '0ed3fc51bb9bb97638f8',
                              clientSecret:
                                  '6c8d7e837b2c7ec2eb96d2c585838c0c0a253708',
                              redirectUrl:
                                  'https://push-notification-gooddelivery.firebaseapp.com/__/auth/handler',
                              scopes: 'read:user,user:email');
                          // Push [GithubSigninScreen] to perform login then get the [GithubSignInResponse]
                          // ignore: use_build_context_synchronously
                          await Navigator.of(context)
                              .push(MaterialPageRoute(builder: (builder) {
                            return GithubSigninScreen(
                              params: params,
                              headerColor: Colors.green,
                              title: 'Login with github',
                            );
                          }));
                          _githubSignInUser(result);
                        })),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              color: themeProvider.themeType == ThemeType.pink
                  ? GlobalVariables.pinkSecondaryColor
                  : GlobalVariables.lightSelectedNavBarColor,
              alignment: Alignment.center,
              child: TextButton(
                  child: Text(
                    AppLocalizations.of(context)!.guestmode,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, BottomBar.routeName);
                  })),
        ],
      ),
    );
  }
}
