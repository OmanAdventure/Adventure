import 'package:flutter/material.dart';
import 'package:untitled/ServiceProviderScreens/TransactionHistoryUI.dart';

import 'AddCommunityActivity.dart';
import 'ManageUsersUI.dart';
import 'RegisteredUsersUI.dart';


void main() {
  runApp(const SuperAdminDashboardApp());
}

class SuperAdminDashboardApp extends StatelessWidget {
  const SuperAdminDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SuperAdminDashboardScreen(),
    );
  }
}

class SuperAdminDashboardScreen extends StatefulWidget {
  const SuperAdminDashboardScreen({super.key});

  @override
  _SuperAdminDashboardScreenState createState() => _SuperAdminDashboardScreenState();
}

class _SuperAdminDashboardScreenState extends State<SuperAdminDashboardScreen> {

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
                      Text('Admin', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
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
                _buildCategoryCard('Onboard a Service Provider', 'assets/images/addAdventure.jpg', () {
                  print('Add Adventure Tapped!');
                //  Navigator.push( context, MaterialPageRoute(builder: (context) => const ServiceProviderAdventureFormPage()),  );
                },disabled: false ),
                _buildCategoryCard('Registered Users', 'assets/images/addCourse.jpg', () {
                  print('Add an adventure course  Tapped!');
                  Navigator.push( context, MaterialPageRoute(builder: (context) =>   RegisteredUsersScreen()),  );
                } ,disabled: false),
                _buildCategoryCard('Manage Users', 'assets/images/corporate.jpg', () {
                  print('Corporate Collaboration Tapped!');
                  Navigator.push( context, MaterialPageRoute(builder: (context) =>   ManageUsersScreen()),  );
                } , disabled: false ),
                 _buildCategoryCard('Transactions History', 'assets/images/cycling.jpg', () {
                   print('Cycling Tapped!');
                   Navigator.push( context, MaterialPageRoute(builder: (context) =>   TransactionsHistoryScreen()),  );
                 }),

                  _buildCategoryCard('Modify Adventures', 'assets/images/beach.jpg', () {
                  print('Cycling Tapped!');  }),
              ],
            ),
            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.fromLTRB(15, 8, 15, 0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Community activities, promoting health and wellness', style: TextStyle(fontSize: 18, ),
                  )
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(20), // Rounded edges for the container
                ),
                height: 250,
                width: double.infinity,
                child: Stack (
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20), // Rounded edges for the image
                      child: const Image(
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        image: AssetImage('assets/images/hiking.jpg'),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.blue[900],
                          backgroundColor: Colors.white, // Text color of the button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {

                          Navigator.push( context, MaterialPageRoute(builder: (context) =>   CommunityActivitiesScreen()),  );

                        }, // Define what the button does when it is pressed
                        child: const Text('Add an Activity'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            /*
            CustomButton(onPressed: () {
              Navigator.push( context,  MaterialPageRoute(builder: (context) =>  const MySubmittedAdventuresScreen(  )), );  }, buttonText: "My Submitted Adventures"),


            CustomButton(onPressed: () {
              Navigator.push( context,  MaterialPageRoute(builder: (context) =>  OnboardServiceProviderScreen(  )), );  }, buttonText: "Edit service provider Profile"),

            CustomButton(onPressed: () {
            Navigator.push( context,  MaterialPageRoute(builder: (context) => ServiceProviderSettingsScreen(),   ), );  }, buttonText: "Service Provider Settings"),
           */


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


}
