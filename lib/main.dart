import 'package:driverid01/firebase_options.dart';
import 'package:driverid01/providers/auth.dart';
import 'package:driverid01/providers/driver_provider.dart';
import 'package:driverid01/providers/maps_provider.dart';
import 'package:driverid01/screens/about_screen.dart';
import 'package:driverid01/screens/all_cars_screen.dart';
import 'package:driverid01/screens/auth_screen.dart';
import 'package:driverid01/screens/car_info_screen.dart';
import 'package:driverid01/screens/earnings_screen.dart';
import 'package:driverid01/screens/home_screen.dart';
import 'package:driverid01/screens/navigation_bar.dart';
import 'package:driverid01/screens/profile_screen.dart';
import 'package:driverid01/screens/ratings_screen.dart';
import 'package:driverid01/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, DriverProvider>(
          create: (_) => DriverProvider(),
          update: (_, auth, driverData) => driverData!..update(auth),
        ),
        ChangeNotifierProxyProvider<DriverProvider, MapsProvider>(
          create: (_) => MapsProvider(),
          update: (_, driver, mapsData) => mapsData!..update(driver),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => Consumer<DriverProvider>(
          builder: (ctx, driver, _) => MaterialApp(
            title: 'Moon Driver App',
            debugShowCheckedModeBanner: false,
            theme: themeData,
            home: auth.isAuth
                ? FutureBuilder(
                    future: driver.fetchDriverDetails(),
                    builder: (ctx, snapshot) => driver.cars.isNotEmpty
                        ? NavigationBar01()
                        : CarInfoScreen(),
                  )
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: routes,
          ),
        ),
      ),
    );
  }

  Map<String, WidgetBuilder> get routes {
    return {
      SplashScreen.routeName: (ctx) => SplashScreen(),
      AuthScreen.routeName: (ctx) => AuthScreen(),
      CarInfoScreen.routeName: (ctx) => CarInfoScreen(),
      NavigationBar01.routeName: (ctx) => NavigationBar01(),
      HomeScreen.routeName: (ctx) => HomeScreen(),
      EarningsScreen.routeName: (ctx) => EarningsScreen(),
      RatingsScreen.routeName: (ctx) => RatingsScreen(),
      ProfileScreen.routeName: (ctx) => ProfileScreen(),
      AboutScreen.routeName: (ctx) => AboutScreen(),
      AllCarsScreen.routeName: (ctx) => AllCarsScreen(),
    };
  }
}

final themeData = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color(0xff423833),
  primaryColorLight: Color(0xffA28F86),
  primaryColorDark: Color(0xff342C28),
  hintColor: Color(0xffD1793F),
  fontFamily: 'Open Sans',
  focusColor: Color(0xffD1793F),
  scaffoldBackgroundColor: Color(0xff423833),
  canvasColor: Color(0xff342C28),
  // canvasColor: Color(0xffB8AAA3),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontSize: 14,
      color: Color(0xff8A756B),
      fontWeight: FontWeight.w700,
    ),
    displayMedium: TextStyle(
      fontSize: 14,
      color: Color(0xff6D5D54),
      fontWeight: FontWeight.w500,
    ),
    displaySmall: TextStyle(
      color: Color(0xffB8AAA3),
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      color: Color(0xffD1793F),
      fontWeight: FontWeight.w700,
    ),
    headlineSmall: TextStyle(
      fontSize: 20,
      color: Color(0xffFBFAF9),
      fontWeight: FontWeight.w700,
    ),
    titleLarge: TextStyle(
      color: Color(0xffA28F86),
      fontSize: 20,
    ),
    bodyMedium: TextStyle(
      color: Color(0xffB8AAA3),
      fontSize: 14,
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xff423833),
    iconTheme: IconThemeData(
      color: Color(0xffD1793F),
    ),
    toolbarTextStyle: TextTheme(
      titleLarge: TextStyle(
        color: Color(0xffA28F86),
        fontSize: 20,
      ),
    ).bodyMedium,
    titleTextStyle: TextTheme(
      titleLarge: TextStyle(
        color: Color(0xffA28F86),
        fontSize: 20,
      ),
    ).titleLarge,
  ),
);
