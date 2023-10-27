import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Constant/Constant.dart';
import 'package:untitled/Screens/PhotoContainerScreen.dart';
import 'package:untitled/Screens/signup.dart';
import 'package:untitled/Screens/userProfile.dart';
import 'SettingsScreen.dart';
import 'PaymentMethodScreen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() => runApp(
    Settings()
);

class Settings extends StatelessWidget {
  Settings();

  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              SizedBox(height: 10.0),
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
            ],
          ),

        ),
        body: // MyApp(),
        const settingsState(),
      ),
    );
  }
}

class settingsState extends StatefulWidget {
  const settingsState({Key? key}) : super(key: key);
  @override
  State<settingsState> createState() => _MySettingsState();
}

class _MySettingsState extends  State<settingsState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFeaeaea),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          _buildButton(
              context,
              text: 'My Profile',
              icon: Icons.person_outline,
              onTap: () {
                User? user = FirebaseAuth.instance.currentUser;
                String userId = "";
                if (user != null) {
                  userId = user.uid;
                  print('Current User ID -->: $userId');
                  // Navigate to My Profile screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  UserScreen()),
                  );

                } else {
                  print('No user is currently logged in.');
                  // User is not logged in, show an alert
                  showDialog(
                  context: context,
                  builder: (BuildContext context) {
                  return AlertDialog(
                  title: const Text("Login Required"),
                  content: const Text("Please login to check your profile."),
                  actions: [
                  TextButton(
                  onPressed: () {
                  Navigator.of(context).pop();
                  },
                  child: const Text("Ok"),
                  ),

                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        _logout();

                             },
                             child: const Text("Let's login"),
                           ),
                         ],
                        );
                      },
                  );

                }

              },
            ),

            _buildButton(
              context,
              text: 'My Adventure',
              icon: Icons.explore_outlined,
              onTap: () {
                // Navigate to My Adventure screen
              },
            ),
            _buildButton(
              context,
              text: 'Payment Method',
              icon: Icons.payment_outlined,
              onTap: () {
                // Navigate to Payment Method screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  const PaymentScreen()),
                );
              },
            ),
            _buildButton(
              context,
              text: 'Share the App with a Friend',
              icon: Icons.share_outlined,

              onTap: () => shareApp(),
            ),

            /*
            _buildButton(
              context,
              text: 'Become a Service Provider',
              icon: Icons.work_outline_outlined,
              onTap: () {
                // Navigate to Become a Service Provider screen
              },
            ),
            */

            _buildButton(
              context,
              text: 'Terms and Conditions',
              icon: Icons.description_outlined,
              onTap: () {
                // Navigate to Terms and Conditions screen
              },
            ),

            _buildButton(
              context,
              text: 'Privacy Policy',
              icon: Icons.privacy_tip_outlined,
              onTap: () {
                // Navigate to Privacy Policy screen
              },
            ),


            if (FirebaseAuth.instance.currentUser == null) // Check if user is logged in
            _buildButton(
              context,
              text:  'Sign In' ,
              icon: Icons.account_circle_outlined,
              onTap: () {

                FirebaseAuth auth = FirebaseAuth.instance;
                auth.signOut().then((res) {


                  // Navigate to a different screen and remove the current screen with the bottom navigation bar
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUp(),
                    ),
                        (route) => false, // This condition ensures that all routes are removed
                  );


                });

              },
            ),
            if (FirebaseAuth.instance.currentUser != null) // Check if user is logged in
            _buildButton(
              context,
              text: 'Logout',
              icon: Icons.exit_to_app_outlined,
              onTap: () {
                _confirmLogout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

// An alert before Signing out
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _logout();
              },
            ),
          ],
        );
      },
    );
  }
// Create a function to handle logout
  Future<void> _logout() async {
    try {
      // Clear cached user data
      await _clearCachedUserData();

      // Sign out of Firebase
      await FirebaseAuth.instance.signOut();

      // Navigate to the login screen or any other desired screen
      FirebaseAuth auth = FirebaseAuth.instance;
      auth.signOut().then((res) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SignUp()),
                (Route<dynamic> route) => false);
      });

      // Replace '/login' with your desired route
    } catch (e) {
      print("Error during logout: $e");
    }
  }

  // Function to clear cached user data
  Future<void> _clearCachedUserData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.clear(); // Clear all cached data
      print("Cached user data cleared");
    } catch (e) {
      print("Error clearing cached user data: $e");
    }
  }

  Widget _buildButton(BuildContext context,
      {required String text, required IconData icon, required void Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );


  } // --

// share the app with a friend function
  void shareApp() async {
    print("object");
    const String appLink = 'https://play.google.com/store/apps/details?id=com.example.myapp';
    const String message = 'Check out my new app: $appLink';
    await Share.share(message, subject: 'Share App');
  }


}
