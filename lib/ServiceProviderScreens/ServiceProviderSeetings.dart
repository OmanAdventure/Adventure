import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:untitled/CustomerScreensUI/ContactUsUI.dart';
import 'package:untitled/CustomerScreensUI/Information&PermissionsUI.dart';
import 'package:untitled/CustomerScreensUI/ManageMyAdventuresUI.dart';
import 'package:untitled/CustomerScreensUI/MyAdventuresUI.dart';
import 'package:untitled/CustomerScreensUI/PaymentMethodUI.dart';
import 'package:untitled/CustomerScreensUI/Terms&ConditionSettingsUI.dart';
import 'package:untitled/CustomerScreensUI/Terms&ConditionsUI.dart';
import 'package:untitled/CustomerScreensUI/UserFeedbackUI.dart';
import 'package:untitled/CustomerScreensUI/UserProfileUI.dart';
//import 'package:untitled/NewScreensUI/Terms&ConditionSettingsUI.dart';
import 'package:untitled/components/CustomAlertUI.dart';

import 'MyCustomerRatingUI.dart';
import 'TransactionHistoryUI.dart';

void main() {
  runApp(const ServiceProviderSettingsScreen());
}

class UserProfileApp extends StatelessWidget {
  const UserProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(

      home: ServiceProviderSettingsScreen(),
    );
  }
}


class ServiceProviderSettingsScreen extends StatefulWidget {
  const ServiceProviderSettingsScreen({super.key});


  @override
  _ServiceProviderSettingsScreenState createState() => _ServiceProviderSettingsScreenState();
}

class _ServiceProviderSettingsScreenState extends State<ServiceProviderSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,

        title: const Text('Settings', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.grey),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blue[900],
                        child: const Icon(Icons.person, color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Service Provider',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Joined Dec 25, 2020',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const Spacer(),

                      //   IconButton( icon: Icon(Icons.edit, color: Colors.blue[900]),onPressed: () {},),


                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('ACCOUNT', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.grey),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.person_outline, color: Colors.blue[900]),
                    title: const Text('My Profile'),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      // Handle my profile action
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  UserProfileScreen(
                          name: 'Fahad Rashed',
                          phone: '123-456-7890',
                          email: 'example@email.com',
                          password: 'ThisIsAPassword',
                          gender: 'Male',
                        )),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.star_outline, color: Colors.blue[900]),
                    title: const Text('My Customer Rating'),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      // Handle manage my booking action
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  CustomerRatingScreen( )),
                      );

                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.build_outlined , color: Colors.blue[900]),
                    title: const Text('Manage My Adventures'),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      // Handle my adventure action

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  MyAdventuresScreen( )),
                      );

                    },
                  ),
                  const Divider(),


                  ListTile(
                    leading: Icon(Icons.info_outline, color: Colors.blue[900]),
                    title: const Text('Information & permissions'),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      // Handle information & permissions action
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  PermissionsScreen(
                        )),
                      );

                    },
                  ),

                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text('SETTINGS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.grey),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.language, color: Colors.blue[900]),
                    title: const Text('Language'),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      // Handle language action
                      _showLanguageDialog(context);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.payment, color: Colors.blue[900]),
                    title: const Text('Payment methods'),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      // Handle payment methods action

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  PaymentScreen( )),
                      );

                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.compare_arrows, color: Colors.blue[900]),
                    title: const Text('Transaction History'),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      // Handle your feedback action


                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  TransactionsHistoryScreen( )),
                      );

                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.feedback_outlined, color: Colors.blue[900]),
                    title: const Text('Your Feedback'),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      // Handle your feedback action


                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  FeedbackScreen( )),
                      );

                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.privacy_tip_outlined, color: Colors.blue[900]),
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      // Handle privacy policy action
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.rule, color: Colors.blue[900]),
                    title: const Text('Terms & Conditions'),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      // Handle terms & conditions action
                      Navigator.push(  context,  MaterialPageRoute(builder: (context) =>  TermsAndConditionsScreenSettings()), );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.share, color: Colors.blue[900]),
                    title: const Text('Share the App with a Friend'),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      // Handle share the app with a friend action
                      shareApp();
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.contact_mail_outlined, color: Colors.blue[900]),
                    title: const Text('Contact Us'),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      // Handle contact us action

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  ContactScreen( )),
                      );


                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  // Handle log out action
                },
                child: const Text('Log out', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _showLanguageDialog(BuildContext context) async {
    Locale currentLocale = Localizations.localeOf(context);
    String selectedLanguage = currentLocale.languageCode;

    await showDialog(
      barrierDismissible : false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(children: [
            Icon(color: Colors.blue[900]! , Icons.language ),
            SizedBox(width: 5,),
            const Text('Choose Language', style: TextStyle(fontSize: 20),),
          ],),
          content: SizedBox(
            height: 120.0, // Adjust the height as needed
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  children: [
                    RadioListTile<String>(
                      fillColor:  MaterialStateProperty.all<Color>(Colors.blue[900]!),
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
                      fillColor:  MaterialStateProperty.all<Color>(Colors.blue[900]!),
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
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel' , style: TextStyle(color: Colors.white),),
            ),
            TextButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blue[900]!),),
              onPressed: () {
                // MyApp.changeLanguage(context, Locale(selectedLanguage));
                Navigator.of(context).pop();
              },
              child:   Text('OK' , style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }


  // share the app with a friend function
  void shareApp() async {
    const String appLink = 'https://play.google.com/store/apps/details?id=com.example.myapp';
    const String message = 'Check out my new app: $appLink';
    await Share.share(message, subject: 'Share App');
  }

}
