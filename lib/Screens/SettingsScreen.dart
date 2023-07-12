import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Screens/PhotoContainerScreen.dart';
import 'SettingsScreen.dart';
import 'PaymentMethodScreen.dart';
import 'package:share_plus/share_plus.dart';

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
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  const [
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
          centerTitle: false,
          backgroundColor: Colors.teal,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: // MyApp(),
        settingsState(),
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
      backgroundColor: Color(0xFFeaeaea),
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
                // Navigate to My Profile screen
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
                  MaterialPageRoute(builder: (context) =>  PaymentScreen()),
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
              icon: Icons.work_outline_outlined,
              onTap: () {
                // Navigate to Become a Service Provider screen
              },
            ),
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
            _buildButton(
              context,
              text: 'Logout',
              icon: Icons.exit_to_app_outlined,
              onTap: () {
                // Perform logout action
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context,
      {required String text, required IconData icon, required void Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Icon(Icons.arrow_forward_ios),
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
