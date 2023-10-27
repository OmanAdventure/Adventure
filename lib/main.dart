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

      final userId = userCredential.user!.uid;
      final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
      final userData = userSnapshot.data();
      // Implement further logic with the retrieved user data
      print('Logged in successfully!');
      // navigate to Home screen
      print('User ID: $userId');
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

// Add more user-related methods and state as needed
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

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
                  child: Text('OK'),
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
      home: const SplashScreen(),
      routes: <String, WidgetBuilder>{

        // to route the notification
        Notifications.route: (context) => const  Notifications(),
       // SignUp.routeName: (BuildContext context) =>   SignUp(),
        SIGNUP_SCREEN: (BuildContext context) => SignUp(),
        HOME_SCREEN: (BuildContext context) => const HomeScreen(),
        ANIMATED_SPLASH: (BuildContext context) => const SplashScreen(),
        ACTIVITY_CONTAINER_SCREEN: (BuildContext context) => const adventuresfunc(),
        ADVENTURES_CONTAINER_SCREEN: (BuildContext context) => const AdventuresContainerScreen(name: ''),
        ACCOMMODATION_CONTAINER_SCREEN: (BuildContext context) => Accommodation(),
        Notifications_CONTAINER_SCREEN: (BuildContext context) => const Notifications(),
        SETTING_CONTAINER_SCREEN: (BuildContext context) => const settingsState(),

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
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(),
    ),
  );

}
