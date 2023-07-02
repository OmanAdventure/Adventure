import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled/firebase_options.dart';
import 'Constant/Constant.dart';
import 'Screens/SettingsScreen.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/PhotoContainerScreen.dart';
import 'Screens/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'shared_preferences.dart';
import 'Screens/Accommodation.dart';
import 'Screens/Adventures.dart';
import 'Screens/signup.dart';
import 'Screens/Notifications.dart';


main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    //title: 'FluterBottemNavigationView',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        indicatorColor: Colors.red,
        highlightColor:  Colors.red,
        bottomAppBarColor: Colors.red,
        primaryColor: Color(0xFFffffff),
        primaryColorDark: Color(0xffffff), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black)),
    home: const SplashScreen(),

    routes: <String, WidgetBuilder>{
      HOME_SCREEN: (BuildContext context) =>   const HomeScreen(),
      ANIMATED_SPLASH: (BuildContext context) =>   const SplashScreen(),
      ACTIVITY_CONTAINER_SCREEN: (BuildContext context) => adventuresfunc(),
      ADVENTURES_CONTAINER_SCREEN: (BuildContext context) => AdventuresContainerScreen(),
      ACCOMMODATION_CONTAINER_SCREEN: (BuildContext context) => Accommodation(),
    //  ALBUM_CONTAINER_SCREEN: (BuildContext context) => AlbumContainerScreen(),
      Notifications_CONTAINER_SCREEN: (BuildContext context) => Notifications()
    },

  ));
}


