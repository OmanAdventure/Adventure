import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
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
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:untitled/l10n/messages_all.dart';
import 'package:untitled/l10n/messages_all_locales.dart';
import 'package:untitled/l10n/messages_en.dart'; // For English
import 'package:untitled/l10n/messages_ar.dart'; // For Arabic

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:untitled/l10n/localization.dart'; // Import your localization file


final navigatorKey = GlobalKey<NavigatorState>();

// UserModel class to represent the user data
class UserModel {

  final String email;
  final String phoneNumber;
  final String gender;
  final String userName;
  final String id;

  UserModel({
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required  this.userName,
    required this.id,
  });
}

// UserProvider class
class UserProvider with ChangeNotifier {
  // User state and methods go here
  Future<void> logInToFb(String email, String password) async {

    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userID = userCredential.user!.uid;
      final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(userID).get();
      final userData = userSnapshot.data();
      // Implement further logic with the retrieved user data
      print('Logged in successfully!');
      // navigate to Home screen
      print('User ID: $userID');
      print('User Data: $userData');
    } catch (error) {
      print('Login failed: $error');
      // Handle login failure, e.g., show an error message to the user
    }
  }

  // Example: Current user data
  UserModel? _user;
  UserModel? get user => _user;

  void updateUser(UserModel newUser) {
    _user = newUser;
    notifyListeners();
  }

}  // UserProvider

class ThemeProvider extends ChangeNotifier {
  bool _darkMode = false;
  bool get darkMode => _darkMode;
  Color darkModeColor =  const Color(0xFF5A5A5A);


  void toggleTheme() {
    _darkMode = !_darkMode;
    notifyListeners();
  }

  ThemeData get themeData {
    // Return the appropriate ThemeData based on _darkMode
    return _darkMode ? darkTheme : lightTheme;
  }


  // Define your light and dark themes as needed
  ThemeData get lightTheme {
    // Define your light theme here
    return ThemeData(
      primaryColor: Colors.teal,
      appBarTheme: AppBarTheme(
        toolbarTextStyle: const TextTheme(
          titleLarge: TextStyle(color: Colors.white), // Set the text color for dark theme
        ).bodyMedium, titleTextStyle: const TextTheme(
          titleLarge: TextStyle(color: Colors.white), // Set the text color for dark theme
        ).titleLarge,
        // Other app bar theme configurations...
      ),
      // Other light theme configurations...
    );
  }

  ThemeData get darkTheme {
    // Define your dark theme here
    return ThemeData(
      primaryColor: darkModeColor,
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white), // Set the text color for dark theme
      ),
      // Other dark theme configurations...
    );
  }
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  // Add the following method
  static _MyAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MyAppState>();
  }

  static void changeLanguage(BuildContext context, Locale locale) {
    _MyAppState? myAppState =
    context.findAncestorStateOfType<_MyAppState>();
    myAppState?.setLocale(locale);
  }
}

String currentuser = "";

class _MyAppState extends State<MyApp> {


  // the visibility of the BottomNavigationBarVisible



// ---------- Languages

  Locale? _locale;

  void setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  static void changeLanguage(BuildContext context, Locale locale) {
    _MyAppState? myAppState =
    context.findAncestorStateOfType<_MyAppState>();
    myAppState?.setLocale(locale);
  }
  // ---------- Language

  late Future<UserModel> _userDataFuture;
  late UserModel _user;

  @override
  void initState() {
    super.initState();




    _locale = const Locale('en');
    _user = UserModel(
      userName: "",
      id: "",
      email: "",
      phoneNumber: "",
      gender: "",
    );

   _userDataFuture = _getUserData();
    print("+++++++++++++");
    print(_user.userName);
    print(_user.id);
    print(_user.email);
    print(_user.gender);

   setState(() {
     print("&&&&&&&&&&&&&&&&&");
         print(_user.userName);
         print(_user.id);
         print(_user.email);
         print(_user.gender);

//     currentuser = _user as String;
        print("This is the current user that you are looking for $currentuser");
     });
  }

  Future<UserModel> _getUserData() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

       currentuser = user as String ;

      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(user.uid).get();

        return UserModel(
          userName: userSnapshot.data()?["UserName"] ?? "",
          id: user.uid,
          email: user.email ?? "",
          phoneNumber: userSnapshot.data()?["Phone Number"] ?? "",
          gender: userSnapshot.data()?["User Gender"] ?? "",
        );
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return _user;
  }

  /// Step 5

  String _lastMessage = "";

  _MyAppState() {

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      try {
        if (kDebugMode) {
          print('Handling a foreground message: ${message.messageId}');
          print('Message data: ${message.data}');
          print('Message notification: ${message.notification?.title}');
          print('Message notification: ${message.notification?.body}');
        }

        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(message.notification?.title ?? 'Notification'),
              content: Text(message.notification?.body ?? 'No content'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        print('Error handling foreground message: $e');
        // Handle the error as needed
      }
    });
  }



  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      /*
      theme: ThemeData(
        indicatorColor: Colors.red,
        highlightColor: Colors.red,
        bottomAppBarColor: Colors.red,
        primaryColor: Color(0xFFffffff),
        primaryColorDark: Color(0xffffff),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.black,
        ),
      ),
      */

      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
        const Locale('ar'), // Arabic
      ],
      locale: _locale,

      builder: (context, child) {
        // Dynamically build the theme based on ThemeProvider
        return Theme(
          data: Provider.of<ThemeProvider>(context).themeData,
          child: child!,
        );
      },

      home: const SplashScreen(  ),
      routes: <String, WidgetBuilder>{

        // to route the notification
        Notifications.route: (context) => const  Notifications(),
       // SignUp.routeName: (BuildContext context) =>   SignUp(),
        SIGNUP_SCREEN: (BuildContext context) => SignUp(),
        HOME_SCREEN: (BuildContext context) => const HomeScreen(),
        ANIMATED_SPLASH: (BuildContext context) => const SplashScreen(),
        ACTIVITY_CONTAINER_SCREEN: (BuildContext context) =>     adventuresfunc(currentIndex: 0),
        ADVENTURES_CONTAINER_SCREEN: (BuildContext context) => const AdventuresContainerScreen(name: ''),
        ACCOMMODATION_CONTAINER_SCREEN: (BuildContext context) => Accommodation(),
        Notifications_CONTAINER_SCREEN: (BuildContext context) => const Notifications(),
        SETTING_CONTAINER_SCREEN: (BuildContext context) => const SettingsState(),

      },
    );
  }



}

// TODO: Add stream controller
// used to pass messages from event handler to the UI
final _messageStreamController = BehaviorSubject<RemoteMessage>();

// TODO: Define the background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();

    if (kDebugMode) {
      print("Handling a background message: ${message.messageId}");
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');

      BuildContext? context = navigatorKey.currentContext;
      if (context != null) {
        // Check if the app is in the foreground

        navigatorKey.currentState?.pushNamed(
          Notifications_CONTAINER_SCREEN,
          arguments: message,
        );

      }
    }
  } catch (e) {
    print('Error handling background message: $e');
    // Handle error gracefully, e.g., log the error or take appropriate action
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // To initialize the firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // TODO: Request permission
  final messaging = FirebaseMessaging.instance;
  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (kDebugMode) {
    print('Permission granted: ${settings.authorizationStatus}');
  }

  // TODO: navigate to the notification screen
  void handleMessage(RemoteMessage? message) {
 //   if (message == null) return;

    BuildContext? context = navigatorKey.currentContext;
    if (context != null) {
      // Check if the app is in the foreground

      navigatorKey.currentState?.pushNamed(
        Notifications_CONTAINER_SCREEN,
        arguments: message,
      );

    }
  }

  // TODO: Register with FCM
  // It requests a registration token for sending messages to users from your App server or other trusted server environment.
  String? token = await messaging.getToken();

  if (kDebugMode) {
    print('Registration Token= $token');
  }

  // TODO: Set up foreground message handler
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    try {
      if (kDebugMode) {
        print('Handling a foreground message: ${message.messageId}');
        print('Message data: ${message.data}');
        print('Message notification: ${message.notification?.title}');
        print('Message notification: ${message.notification?.body}');
      }
      _messageStreamController.sink.add(message);
    } catch (e) {
      print('Error handling foreground message: $e');
      // Handle the error as needed
    }
  });

  // TODO: Set up background message handler

  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        // Add other providers if needed
      ],
      child: MyApp(),
    ),
  );

}
