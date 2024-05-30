import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/CustomAlertUI.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ManageUsersScreen(),
    );
  }
}

class ManageUsersScreen extends StatefulWidget {
  @override
  _ManageUsersScreenState createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  // Dynamic variables for segmented control and user data
  String selectedSegment = 'Service Providers';
  final List<Map<String, String>> serviceProviders = [
    {
      'name': 'Service Provider Full Name',
      'email': 'Email@Email.com',
      'phone': 'Phone Number',
      'gender': 'Gender',
      'joined': 'Joined Date',
    },
    {
      'name': 'Service Provider Full Name',
      'email': 'Email@Email.com',
      'phone': 'Phone Number',
      'gender': 'Gender',
      'joined': 'Joined Date',
    },
  ];

  final List<Map<String, String>> customers = [
    {
      'name': 'Customer Full Name',
      'email': 'Email@Email.com',
      'phone': 'Phone Number',
      'gender': 'Gender',
      'joined': 'Joined Date',
    },
    {
      'name': ' Customer Full Name',
      'email': 'Email@Email.com',
      'phone': 'Phone Number',
      'gender': 'Gender',
      'joined': 'Joined Date',
    },
    {
      'name': ' Customer Full Name',
      'email': 'Email@Email.com',
      'phone': 'Phone Number',
      'gender': 'Gender',
      'joined': 'Joined Date',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        title: Text('Manage Users', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Segmented Control
              CupertinoSlidingSegmentedControl<String>(
                backgroundColor: Colors.grey[200]!,
                thumbColor: Colors.blue[900]!,
                groupValue: selectedSegment,
                onValueChanged: (value) {
                  setState(() {
                    selectedSegment = value!;
                  });
                },
                children: {
                  'Service Providers': Text('Service Providers', style: TextStyle(color: selectedSegment == 'Service Providers' ? Colors.white : Colors.black)),
                  'Customers': Text('Customers', style: TextStyle(color: selectedSegment == 'Customers' ? Colors.white : Colors.black)),
                },
              ),
              SizedBox(height: 16),
              // User List
              ...((selectedSegment == 'Service Providers' ? serviceProviders : customers).map((user) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue[900],
                          child: Icon(Icons.person, color: Colors.white, size: 30),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user['name']!, style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(user['email']!),
                            Text(user['phone']!),
                            Text(user['gender']!),
                            Text(user['joined']!),
                          ],
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.refresh, color: Colors.green),
                          onPressed: () {
                            // Handle refresh button press

                            _showConfirmationDialog( context);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList()),
            ],
          ),
        ),
      ),
    );
  }


  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 8),
              Text('Confirm Restoration'),
            ],
          ),
          content: const Text('Are you sure that you want to restore this user account?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {

                // Add your action for the Yes button here
                Navigator.of(context).pop(); // Close the current alert
                _restoreConfirmation(context); // Show the new alert

                // Refresh the page immediallty
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[900],
              ),
              child: const Text('Yes',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _restoreConfirmation(BuildContext context){

    showDialog(
      context: context,
      barrierDismissible : false,
      builder: (BuildContext context) {
        return Center(
          child: CustomDialog(
            title: '\n\nUser Account Restored Successfully!',
            message: ' ',
            buttonText: 'OK',
            onButtonPressed: () {
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

}
