import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gooddelivary/common/widgets/bottom_bar.dart';
import 'package:gooddelivary/constants/enums.dart';
import 'package:gooddelivary/constants/global_variables.dart';
import 'package:gooddelivary/features/admin/screens/admin_screen.dart';
import 'package:gooddelivary/features/admin/services/admin_services.dart';
import 'package:gooddelivary/features/auth/services/auth_service.dart';
import 'package:gooddelivary/common/config/firebase_options.dart';
import 'package:gooddelivary/l10n/l10n.dart';
import 'package:gooddelivary/providers/locale_provider.dart';
import 'package:gooddelivary/providers/location_provider.dart';
import 'package:gooddelivary/providers/theme_provider.dart';
import 'package:gooddelivary/providers/user_provider.dart';
import 'package:gooddelivary/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'features/auth/screens/auth_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.instance.getToken().then((value) {
    if (kDebugMode) {
      print("getToken: $value");
    }
  });

  // If app work in foreground mode
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      // Show notification
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'channel.id',
              'channel.name',
              channelDescription: 'channel.description',
              importance: Importance.high,
              icon: android.smallIcon,
            ),
          ));
    }

    Navigator.pushNamed(
      navigatorKey.currentState!.context,
      '/actual-home',
    );
  });

  // If app work in background mode
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    Navigator.pushNamed(
      navigatorKey.currentState!.context,
      '/actual-home',
    );
  });

  // If app is closed or terminated
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      Navigator.pushNamed(
        navigatorKey.currentState!.context,
        '/actual-home',
      );
    }
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
    ),
    ChangeNotifierProvider(create: (context) => LocationProvider()),
  ], child: const MyApp()));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  final AuthService _authService = AuthService();
  final AdminServices _adminServices = AdminServices();

  @override
  void initState() {
    super.initState();
    _authService.getUserData(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    _adminServices.ordersStatusForAdmin(context);

    return ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: Consumer<ThemeProvider>(
            builder: (context, ThemeProvider themeNotifier, child) {
          return MaterialApp(
              title: 'GoodDelivary',
              theme: themeNotifier.themeType == ThemeType.light
                  ? lightThemeData()
                  : themeNotifier.themeType == ThemeType.dark
                      ? darkThemeData()
                      : pinkThemeData(),
              locale: localeProvider.locale,
              supportedLocales: L10n.all,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              onGenerateRoute: (settings) => generateRoute(settings),
              navigatorKey: navigatorKey,
              home: Provider.of<UserProvider>(context).user.token.isNotEmpty
                  ? Provider.of<UserProvider>(context).user.type == 'user'
                      ? const BottomBar()
                      : const AdminScreen()
                  : const AuthScreen());
        }));
  }

  ThemeData pinkThemeData() {
    return ThemeData(
      scaffoldBackgroundColor: GlobalVariables.pinkBackSecondaryColor,
      snackBarTheme: const SnackBarThemeData(
          backgroundColor: GlobalVariables.pinkGreyBackgroundCOlor),
      radioTheme: const RadioThemeData(
          fillColor:
              MaterialStatePropertyAll(GlobalVariables.pinkSecondaryColor)),
      appBarTheme: const AppBarTheme(
          backgroundColor: GlobalVariables.pinkGreyBackgroundCOlor),
      colorScheme:
          const ColorScheme.light(primary: GlobalVariables.pinkSecondaryColor),
    );
  }

  ThemeData lightThemeData() {
    return ThemeData(
        snackBarTheme: SnackBarThemeData(
            backgroundColor: GlobalVariables.lightSelectedNavBarColor),
        radioTheme: const RadioThemeData(
            fillColor:
                MaterialStatePropertyAll(GlobalVariables.lightSecondaryColor)),
        scaffoldBackgroundColor: GlobalVariables.lightBackgroundColor,
        colorScheme: const ColorScheme.light(
            primary: GlobalVariables.lightSecondaryColor),
        appBarTheme: const AppBarTheme(elevation: 0),
        iconTheme: const IconThemeData(color: Colors.black));
  }

  ThemeData darkThemeData() {
    return ThemeData(
      snackBarTheme: const SnackBarThemeData(
          backgroundColor: GlobalVariables.darkButtonBackgroundCOlor,
          contentTextStyle: TextStyle(color: Colors.white)),
      radioTheme: const RadioThemeData(
          fillColor:
              MaterialStatePropertyAll(GlobalVariables.darkSecondaryColor)),
      appBarTheme: const AppBarTheme(
          backgroundColor: GlobalVariables.darkGreyBackgroundCOlor),
      colorScheme:
          const ColorScheme.dark(primary: GlobalVariables.darkSecondaryColor),
    );
  }
}
