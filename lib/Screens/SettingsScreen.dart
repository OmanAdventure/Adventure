import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Constant/Constant.dart';
import 'package:untitled/CustomerScreensUI/AdventureDetailsUI.dart';
import 'package:untitled/CustomerScreensUI/CommunityActivitiesUI.dart';
import 'package:untitled/CustomerScreensUI/FilterAdventureUI.dart';
import 'package:untitled/CustomerScreensUI/ForgetPasswordUI.dart';
import 'package:untitled/CustomerScreensUI/HomeScreenUI.dart';
import 'package:untitled/CustomerScreensUI/LoginScreenUI.dart';
import 'package:untitled/CustomerScreensUI/NotificationDetailsUI.dart';
import 'package:untitled/CustomerScreensUI/NotificationUI.dart';
import 'package:untitled/CustomerScreensUI/ReviewConfirmUI.dart';
import 'package:untitled/CustomerScreensUI/SettingsScreenUI.dart';
import 'package:untitled/CustomerScreensUI/SuccessfulBookingUI.dart';
import 'package:untitled/CustomerScreensUI/Terms&ConditionsUI.dart';
import 'package:untitled/CustomerScreensUI/TurnOnNotificationUI.dart';
import 'package:untitled/Screens/MyAchievement.dart';
import 'package:untitled/Screens/MyBookedAdventures.dart';
import 'package:untitled/CustomerScreensUI/RateServiceProviderUI.dart';
import 'package:untitled/Screens/PhotoContainerScreen.dart';
import 'package:untitled/CustomerScreensUI/SelectAdventureUI.dart';
import 'package:untitled/CustomerScreensUI/SignUpScreenUI.dart';
import 'package:untitled/CustomerScreensUI/countryLanguage.dart';
import 'package:untitled/Screens/signup.dart';
import 'package:untitled/Screens/userProfile.dart';
import 'package:untitled/l10n/localization.dart';
import 'package:url_launcher/url_launcher.dart';
import '../AdminScreenUI/AdminDashboardUI.dart';
import '../ServiceProviderScreens/ServiceProviderDashboardUI.dart';
import '../main.dart';
import 'serviceProviderForm.dart';
import 'SettingsScreen.dart';
import 'PaymentMethodScreen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:untitled/l10n/messages_all.dart';
import 'package:untitled/l10n/messages_all_locales.dart';
import 'package:untitled/l10n/messages_en.dart'; // For English
import 'package:untitled/l10n/messages_ar.dart'; // For Arabic
import 'package:intl/intl.dart';


void main() => runApp(
   const Settings()
);

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final appBarColor = themeProvider.darkMode
        ? themeProvider.darkTheme.primaryColor
        : const Color(0xFF700464);

    return   MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
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
                      color: Colors.white
                ),
              ),
              SizedBox(height: 10.0),
            ],
          ),

        ),
        body: // MyApp(),
        const SettingsState(),
      ),
    );
  }
}

class SettingsState extends StatefulWidget {
  const SettingsState({Key? key}) : super(key: key);
  @override
  State<SettingsState> createState() => _MySettingsState();
}

class _MySettingsState extends  State<SettingsState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFeaeaea),
     // backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),

       child: Padding(
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
                String userID = "";
                if (user != null) {
                  userID = user.uid;
                  print('Current User ID -->: $userID');
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
                  child: const Text("Ok", style: TextStyle(color: Color(0xFF700464))),
                  ),

                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        _logout();
                             },
                             child: const Text("Let's login", style: TextStyle(color: Color(0xFF700464))),
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
              text: 'Change Language',
              icon: Icons.language,
                onTap: () => _showLanguageDialog(context) // Switch to Arabic
            ),


            _buildButton(
              context,
              text: 'My Adventures',
              icon:  Icons.explore_outlined,
              onTap: () {
                User? user = FirebaseAuth.instance.currentUser;
                String userID = "";
                if (user != null) {
                  userID = user.uid;
                  print('Current User ID -->: $userID');
                  // Navigate to My Profile screen

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyBookedAdventuresState()),
                  );

                } else {
                  if (kDebugMode) {
                    print('No user is currently logged in.');
                  }
                  // User is not logged in, show an alert
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Login Required"),
                        content: const Text("Please login to check your Adventures."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Ok", style: TextStyle(color: Color(0xFF700464))),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                              _logout();
                            },
                            child: const Text("Let's login", style: TextStyle(color: Color(0xFF700464))),
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
              text: 'My Achievements',
              icon: Icons.celebration_outlined,

              onTap: () {
                User? user = FirebaseAuth.instance.currentUser;
                String userID = "";
                if (user != null) {
                  userID = user.uid;
                  print('Current User ID -->: $userID');
                  // Navigate to My Achievements screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  const PointsBadgesScreen(
                      uuid: '',
                      adventureProviderName: '',
                      adventureID: '',
                      typeOfAdventure: '',
                      difficultyLevel: '',
                      price: '',
                    )
                    ),
                  );
                } else {
                  print('No user is currently logged in.');
                  // User is not logged in, show an alert
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Login Required"),
                        content: const Text("Please login to view what you have achieved."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Ok", style: TextStyle(color: Color(0xFF700464))),
                          ),

                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                              _logout();

                            },
                            child: const Text("Let's login", style: TextStyle(color: Color(0xFF700464))),
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


            _buildButton(
              context,
              text: 'Become a Service Provider',
              icon: Icons.category_outlined,
              onTap: () {
                User? user = FirebaseAuth.instance.currentUser;
                String userID = "";
                if (user != null) {
                  userID = user.uid;
                  print('Current User ID -->: $userID');
                  // Navigate to My Profile screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  ServiceProviderRegistrationScreen()),
                  );

                } else {
                  print('No user is currently logged in.');
                  // User is not logged in, show an alert
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Login Required"),
                        content: const Text("Please login to become a service provider."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Ok", style: TextStyle(color: Color(0xFF700464))),
                          ),

                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                              _logout();

                            },
                            child: const Text("Let's login", style: TextStyle(color: Color(0xFF700464))),
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
              text: 'Terms and Conditions',
              icon: Icons.description_outlined,
              onTap: () {
                // Navigate to Terms and Conditions screen
                final snackBar = SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: const Text('Do you want to check Terms and Conditions?'),
                  action: SnackBarAction(
                    label: 'Open',textColor: Colors.red,
                    onPressed: () async {

                      final Uri url = Uri.parse('https://policies.google.com/terms?hl=en-US');
                      if (!await launchUrl(url)) {
                        throw Exception('Could not launch $url');
                      }

                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

              },
            ),

            _buildButton(
              context,
              text: 'Privacy Policy',
              icon: Icons.privacy_tip_outlined,
              onTap: () {
                // Navigate to Terms and Conditions screen
                final snackBar = SnackBar(
                  behavior: SnackBarBehavior.floating,

                  content: const Text('Do you want to check Privacy Policy?'),
                  action: SnackBarAction(
                    label: 'Open', textColor: Colors.red,
                    onPressed: () async {
                      final Uri url = Uri.parse('https://policies.google.com/terms?hl=en-US');
                      if (!await launchUrl(url)) {
                        throw Exception('Could not launch $url');
                      }
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

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

            ///-----------------------------------------
            _buildButton(
              context,
              text: 'SP Feedback Screen',
              icon: Icons.adb_rounded,
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  const RatingScreen()),
                );

              },
            ),


            _buildButton(
              context,
              text: 'Country and Language Screen ',
              icon: Icons.adb_rounded,
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  const LanguageAndCountrySelector()),
                );

              },
            ),


            _buildButton(
              context,
              text: 'Login Screen UI ',
              icon: Icons.adb_rounded,
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  const LoginScreen()),
                );

              },
            ),


            _buildButton(
              context,
              text: 'Sign-Up Screen UI ',
              icon: Icons.adb_rounded,
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  SignUpScreen()),
                );

              },
            ),

            _buildButton(
              context,
              text: 'Home Screen ',
              icon: Icons.adb_rounded,
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  AdventureScreen()),
                );

              },
            ),


            _buildButton(
              context,
              text: 'Select Adventure',
              icon: Icons.adb_rounded,
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  const AdventureDetails()),
                );

              },
            ),


            _buildButton(
              context,
              text: 'Filter Adventure',
              icon: Icons.adb_rounded,
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  FilterScreen()),
                );

              },
            ),


            // AdventureBookingScreen
            _buildButton(
              context,
              text: 'AdventureBookingScreen',
              icon: Icons.adb_rounded,
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  const AdventureBookingScreen(
                    serviceProviderName: "Service Provider Name",
                    description: "Adventure Description Adventure Description Adventure Description Adventure Description Adventure Description Adventure Description Adventure Description Adventure Description",
                    startDate: "2024/02/02",
                    startTime: "14:00",
                    endDate: "2024/02/02",
                    endTime: "18:00",
                    totalParticipants: 20,
                    pricePerPerson: 10,

                  )),
                );

              },
            ),



            _buildButton(
              context,
              text: 'Review & Confirm',
              icon: Icons.adb_rounded,
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReviewAndConfirmScreen(
                    serviceProviderName: "Service Provider Name",
                    date: "Friday, December 22, 2024",
                    time: "03:00 PM - 06:00 PM",
                    location: "Adventure Box Store",
                    price: 15,
                    tickets: 4,
                    tax: 0,
                   ),
                  ),
                );

              },
            ),


            _buildButton(
              context,
              text: 'Successful Booking ',
              icon: Icons.adb_rounded,
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  SuccessfulBookingScreen()),
                );

              },
            ),


            _buildButton(
              context,
              text: 'Terms & Conditions',
              icon: Icons.adb_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TermsAndConditionsScreen(),
                  ),
                );
              },
            ),

            _buildButton(
              context,
              text: 'Community Activities ',
              icon: Icons.adb_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  CommunityActivitiesScreen( )),
                );
              },
            ),

            _buildButton(
              context,
              text: 'Settings Screen',
              icon: Icons.adb_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  SettingsScreen()),
                );
              },
            ),


            _buildButton(
              context,
              text: 'Forget Password Screen',
              icon: Icons.adb_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  ForgetPasswordScreen()),
                );
              },
            ),


            _buildButton(
              context,
              text: 'Notification',
              icon: Icons.adb_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  NotificationApp()),
                );
              },
            ),

            _buildButton(
              context,
              text: 'Turn On Notification',
              icon: Icons.adb_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  NotificationPromptScreen()),
                );
              },
            ),


            _buildButton(
              context,
              text: 'Notification Details',
              icon: Icons.adb_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  NotificationDetailsScreen(
                    serviceProviderName: "Service Provider Name",
                    description: "Adventure Description Adventure Description Adventure Description Adventure Description Adventure Description Adventure Description Adventure Description Adventure Description",
                    startDate: "2024/02/02",
                    startTime: "14:00",
                    endDate: "2024/02/02",
                    endTime: "18:00",
                    totalParticipants: 20,
                    pricePerPerson: 10,

                  )),
                );
              },
            ),
            //// ---------------------------------


            _buildButton(
              context,
              text: 'Service Provider Screens',
              icon: Icons.adb_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  SPDashboardScreen()),
                );
              },
            ),


            _buildButton(
              context,
              text: 'Admin Screens',
              icon: Icons.adb_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  SuperAdminDashboardScreen()),
                );
              },
            ),

            /// ----------------------------
          ],
        ),
      ),

    )
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
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF700464))),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Logout', style: TextStyle(color: Color(0xFF700464))),
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
     const String appLink = 'https://play.google.com/store/apps/details?id=com.example.myapp';
    const String message = 'Check out my new app: $appLink';
    await Share.share(message, subject: 'Share App');
  }

  Future<void> _showLanguageDialog(BuildContext context) async {
    Locale currentLocale = Localizations.localeOf(context);
    String selectedLanguage = currentLocale.languageCode;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Language'),
          content: SizedBox(
            height: 120.0, // Adjust the height as needed
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('English'),
                      value: 'en',
                      groupValue: selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          selectedLanguage = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Arabic'),
                      value: 'ar',
                      groupValue: selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          selectedLanguage = value!;
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),

          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
               // MyApp.changeLanguage(context, Locale(selectedLanguage));
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

}
