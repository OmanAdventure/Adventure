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
      home: RegisteredUsersScreen(),
    );
  }
}

class RegisteredUsersScreen extends StatefulWidget {
  @override
  _RegisteredUsersScreenState createState() => _RegisteredUsersScreenState();
}

class _RegisteredUsersScreenState extends State<RegisteredUsersScreen> {
  // Dynamic variables for segmented control and user data



  String selectedSegment = 'Service Providers';
  final List<Map<String, String>> serviceProviders = [
    {
      'name': 'Service Providers Full Name',
      'email': 'Email@Email.com',
      'services': 'Provided Services',
      'phone': 'Phone Number',
      'business': 'Business Name',
      'reviews': '42',
      'rating': '5.0',
    },
    {
      'name': 'Service Providers Full Name',
      'email': 'Email@Email.com',
      'services': 'Provided Services',
      'phone': 'Phone Number',
      'business': 'Business Name',
      'reviews': '42',
      'rating': '5.0',
    },
  ];

  final List<Map<String, String>> customers = [
    {
      'name': 'customers Full Name',
      'email': 'Email@Email.com',
      'phone': 'Phone Number',
      'gender': 'Gender',
      'joined': 'Joined Date',
    },
    {
      'name': 'customers Full Name',
      'email': 'Email@Email.com',
      'phone': 'Phone Number',
      'gender': 'Gender',
      'joined': 'Joined Date',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //   backgroundColor: const Color(0xFFeaeaea),
      appBar: AppBar(

        title: const Text('Registered Users', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(0),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)
                ),
                height: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                
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
                    
                  ],
                ),
              ),
              
              // Segmented Control
           
              const SizedBox(height: 16),
              // User List
              ...((selectedSegment == 'Service Providers' ? serviceProviders : customers).map((user) {
                return Card(
                 // color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.blue[900],
                              child: const Icon(Icons.person, color: Colors.white, size: 30),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                                   // if (selectedSegment == 'Service Providers')
                                   //  Icon(Icons.star, color: Colors.blue[900]),
                                   //  Text('${user['rating']!} (${user['reviews']!} reviews)'),
                                  ],
                                ),
                                Text(user['email']!),
                                if (selectedSegment == 'Service Providers') Text(user['services']!),
                                Text(user['phone']!),
                                if (selectedSegment == 'Service Providers') Text(user['business']!),

                                if (selectedSegment == 'Customers')
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(user['gender']!),
                                      Text(user['joined']!),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),





                        // Buttons Sections
                        const SizedBox(height: 16),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (selectedSegment == 'Service Providers')
                              // location
                              IconButton(
                                icon: Icon(Icons.location_pin, color: Colors.blue[900]),
                                onPressed: () {
                                  // Handle location button press
                                },
                              ),
                              const Spacer(),
                              // Delete
                              IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Handle delete button press
                                _showDeletionConfirmationDialog(context);
                              },
                            ),
                            if (selectedSegment == 'Service Providers')
                              // Edit
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue[900]),
                                onPressed: () {
                                  // Handle edit button press
                                },
                              ),
                          ],
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



  void _showDeletionConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        bool tcViolation = false;
        bool fraud = false;
        bool reason1 = false;
        bool reason2 = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              title: const Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('Confirm Deletion', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Are you sure that you want to delete this user?'),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      CheckboxListTile(
                        title: const Text('T&C Violation'),
                        value: tcViolation,
                        onChanged: (bool? value) {
                          setState(() {
                            tcViolation = value!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Fraud'),
                        value: fraud,
                        onChanged: (bool? value) {
                          setState(() {
                            fraud = value!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Reason 1'),
                        value: reason1,
                        onChanged: (bool? value) {
                          setState(() {
                            reason1 = value!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Reason 2'),
                        value: reason2,
                        onChanged: (bool? value) {
                          setState(() {
                            reason2 = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        // Print the values in the console
                        print('T&C Violation: $tcViolation');
                        print('Fraud: $fraud');
                        print('Reason 1: $reason1');
                        print('Reason 2: $reason2');

                        Navigator.of(context).pop();

                        _deleteConfirmation(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                      ),
                      child: const Text(
                        'Yes',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),




              ],
            );
          },
        );
      },
    );
  }
  void _deleteConfirmation(BuildContext context){

    showDialog(
      context: context,
      barrierDismissible : false,
      builder: (BuildContext context) {
        return Center(
          child: CustomDialog(
            title: '\n\nProfile Deleted Successfully!',
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







/*

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegisteredUsersScreen(),
    );
  }
}

class RegisteredUsersScreen extends StatefulWidget {
  @override
  _RegisteredUsersScreenState createState() => _RegisteredUsersScreenState();
}

class _RegisteredUsersScreenState extends State<RegisteredUsersScreen> {
  String selectedSegment = 'Service Providers';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        title: Text('Registered Users', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
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
          Expanded(
            child: selectedSegment == 'Service Providers' ? ServiceProviderList() : CustomerList(),
          ),
        ],
      ),
    );
  }
}

class ServiceProviderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('service_providers').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final serviceProviders = snapshot.data!.docs;

        return ListView.builder(
          itemCount: serviceProviders.length,
          itemBuilder: (context, index) {
            var user = serviceProviders[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                            Text(user['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(user['email']),
                            Text(user['services']),
                            Text(user['phone']),
                            Text(user['business']),
                          ],
                        ),
                        Spacer(),
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.blue[900]),
                                Text('${user['rating']} (${user['reviews']} reviews)'),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.location_pin, color: Colors.blue[900]),
                          onPressed: () {
                            // Handle location button press
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Handle delete button press
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue[900]),
                          onPressed: () {
                            // Handle edit button press
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class CustomerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('customers').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final customers = snapshot.data?.docs;

        return ListView.builder(
          itemCount: customers?.length,
          itemBuilder: (context, index) {
            var user = customers?[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                            Text(user!['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(user!['email']),
                            Text(user!['phone']),
                            Text(user['gender']),
                            Text(user['joined']),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Handle delete button press
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}


 */