// ignore_for_file: prefer_const_constructors

import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/routes.dart';
import 'package:flutter/material.dart';

import 'features/screens/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Amazone Clone',
        theme: ThemeData(
            scaffoldBackgroundColor: GlobalVariables.backgroundColor,
            colorScheme:
                ColorScheme.light(primary: GlobalVariables.secondaryColor),
            appBarTheme: const AppBarTheme(elevation: 0),
            iconTheme: IconThemeData(color: Colors.black)),
        onGenerateRoute: (settings) => generateRoute(settings),
        home: const AuthScreen());
  }
}
