import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:provider/provider.dart';
import 'firebase_options.dart';

// UserModel: Represents the data structure for a user, containing information like name, email, phone number, and gender.
// UserProvider: Manages the user state and provides methods to update and retrieve user data.
// notifyListeners: Notifies all registered listeners (typically widgets) that are consuming the ChangeNotifierProvider when the user state changes.
// ChangeNotifierProvider: A widget from the provider package that allows you to provide a ChangeNotifier (such as UserProvider) to the widget tree, making it available to all child widgets that need access to the user state.
//

// UserModel class to represent the user data
class UserModel {
  final String name;
  final String email;
  final String phoneNumber;
  final String gender;

  UserModel({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.gender,
  });
}

// UserProvider class
class UserProvider with ChangeNotifier {
  // User state and methods go here
  Future<void> logInToFb(String email, String password) async {

    try {
      // final email = emailController.text;
      //  final password = passwordController.text;
      //  final UserCredential userCredential =
      // await auth.signInWithEmailAndPassword(
      //    email: email,
      //    password: password,
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(), // Provide the UserProvider here
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
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
              secondary: Colors.black)),

      home: const SplashScreen(),
      routes: <String, WidgetBuilder>{
        HOME_SCREEN: (BuildContext context) => const HomeScreen(),
        ANIMATED_SPLASH: (BuildContext context) => const SplashScreen(),
        ACTIVITY_CONTAINER_SCREEN: (BuildContext context) => adventuresfunc(),
        ADVENTURES_CONTAINER_SCREEN: (BuildContext context) =>
            AdventuresContainerScreen(name: '',),
        ACCOMMODATION_CONTAINER_SCREEN: (BuildContext context) =>
            Accommodation(),
        // ALBUM_CONTAINER_SCREEN: (BuildContext context) => AlbumContainerScreen(),
        Notifications_CONTAINER_SCREEN: (BuildContext context) =>
            Notifications(),
        SETTING_CONTAINER_SCREEN: (BuildContext context) => settingsState(),
      },

    );
    //);
  }
}

