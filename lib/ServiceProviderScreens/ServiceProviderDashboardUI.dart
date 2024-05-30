import 'package:flutter/material.dart';

import '../components/CustomAlertUI.dart';
import '../components/buttonsUI.dart';
import 'AddAdventureFormUI.dart';
import 'MySubmittedAdventureUI.dart';
import 'OnBoardServiceProvider.dart';
import 'ServiceProviderSeetings.dart';

void main() {
  runApp(SPDashboardApp());
}

class SPDashboardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SPDashboardScreen(),
    );
  }
}

class SPDashboardScreen extends StatefulWidget {
  @override
  _SPDashboardScreenState createState() => _SPDashboardScreenState();
}

class _SPDashboardScreenState extends State<SPDashboardScreen> {

  String dropdownValue = 'Oman'; // Initial value


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color(0xFFeaeaea), // Light grey background color
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // Set this height to your preference
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          title: Padding(
            padding:  const EdgeInsets.fromLTRB(8, 23, 8, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Icon(Icons.ac_unit, color: Colors.blue[900]),
                ),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Welcome', style: TextStyle(color: Colors.black, fontSize: 14)),
                      Text('Service Provider XYZ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black), // Blue border around DropdownButton
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: DropdownButton<String>(
                    dropdownColor: Colors.white,  // Optional: Changes the background color of the dropdown
                    borderRadius: BorderRadius.circular(40),
                    underline: Container(), // No underline
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                    value: dropdownValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: <String>['Oman', 'Option 2', 'Option 3']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                  ),
                ),



              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
             const Padding(
                padding:  EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Services Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                )
            ),

            GridView.count(
              shrinkWrap: true,
              physics:  const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              children: <Widget>[
                _buildCategoryCard('Add Adventure', 'assets/images/addAdventure.jpg', () {
                  print('Add Adventure Tapped!');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ServiceProviderAdventureFormPage()),
                  );
                  },disabled: false ),
                _buildCategoryCard('Add an adventure course', 'assets/images/addCourse.jpg', () {
                  print('Add an adventure course  Tapped!');
                  showComingSoonAlert(context);
                } ,disabled: false),
                _buildCategoryCard('Corporate Collaboration', 'assets/images/corporate.jpg', () {
                  print('Corporate Collaboration Tapped!');
                  showComingSoonAlert(context);
                     } , disabled: false ),
                // _buildCategoryCard('Cycling', 'assets/images/cycling.jpg', () {
                //   print('Cycling Tapped!');  }),
              ],
            ),
             const SizedBox(height: 20),

            CustomButton(onPressed: () {
              Navigator.push( context,  MaterialPageRoute(builder: (context) =>  const MySubmittedAdventuresScreen(  )), );
            }, buttonText: "My Submitted Adventures"),


            CustomButton(onPressed: () {
              Navigator.push( context,  MaterialPageRoute(builder: (context) =>  OnboardServiceProviderScreen(  )), );
            }, buttonText: "Edit service provider Profile"),

            CustomButton(onPressed: () {
              Navigator.push( context,  MaterialPageRoute(builder: (context) => ServiceProviderSettingsScreen(),
                  ), );
            }, buttonText: "Service Provider Settings"),

          ],
        ),
      ),

    );
  }


  Widget _buildCategoryCard(String title, String imagePath, VoidCallback onTap, {bool disabled = false}) {
    return Padding(
      padding:  const EdgeInsets.fromLTRB(15, 10, 15, 8), // Add padding around each card
      child:  GestureDetector(
        onTap: disabled ? null : onTap, // If disabled, don't respond to taps
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: disabled ? Colors.grey.shade300 : Colors.white, // Set the background color to grey if disabled
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                color: disabled ? Colors.grey.withOpacity(0.5) : null, // Set the color to grey if disabled
                colorBlendMode: disabled ? BlendMode.color : BlendMode.src, // Set the blend mode to color if disabled
              ),
              Container(
                color: Colors.black.withOpacity(0.5),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  title,
                  style: TextStyle(color: disabled ? Colors.grey.shade200 : Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  void showComingSoonAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible : false,
      builder: (BuildContext context) {
        return   AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              titlePadding: EdgeInsets.zero,
              contentPadding:  const EdgeInsets.all(30.0),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sentiment_satisfied_alt_rounded, size: 80, color: Colors.blue[900]),
                  const SizedBox(height: 10),
                  Text(
                      "Coming Soon" ,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "This feature is not available yet.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 60),
                  CustomButton(
                    onPressed: () { Navigator.pop(context);},
                    buttonText: "Ok",
                  ),
                ],
              ),
            );

      },
    );
  }

}
