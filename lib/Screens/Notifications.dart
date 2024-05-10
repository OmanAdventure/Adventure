import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:untitled/Screens/NotificationDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:untitled/Screens/signup.dart';

import '../main.dart';

void main() => runApp(
    const Notifications()
);

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  static const route = '/NotificationsScreen';

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MyNotificationState(),
      ),
    );
  }
}

class MyNotificationState extends StatefulWidget {
  const MyNotificationState({Key? key}) : super(key: key);
  @override
  State<MyNotificationState> createState() => _MyNotificationContainerState();
}

class _MyNotificationContainerState extends State<MyNotificationState> {
  late Stream<QuerySnapshot> _adventuresStream;
 // late List<Map<String, dynamic>> _cachedAdventures = [];
 // late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();

    User? user = FirebaseAuth.instance.currentUser;
    String userID = "";
    if (user != null) {
      userID = user.uid;
    }

    _adventuresStream = FirebaseFirestore.instance
        .collection('BookedAdventure').where("userID", isEqualTo: userID )
        //.orderBy('adventureBookingDate', descending: true)
        .snapshots();
// -----------------------------------------
    /*
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _prefs = prefs;
        _initPrefs(); // Call _initPrefs() after setting _prefs variable
        final String? adventuresJson = prefs.getString('BookedAdventure');
        if (adventuresJson != null) {
          final List<dynamic> adventuresData = jsonDecode(adventuresJson);
          _cachedAdventures = adventuresData
              .map((adventureData) => Map<String, dynamic>.from(adventureData))
              .toList();
        }
      });
    });
    */
  }

/*
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }
 */

  // ----------------------------------------------------


  @override
  Widget build(BuildContext context) {

    // to get the notification message
    final message = ModalRoute.of(context)!.settings.arguments;
    if (kDebugMode) {
      print("Notification Message");
      print(message);
    }


    final themeProvider = Provider.of<ThemeProvider>(context);
    final appBarColor = themeProvider.darkMode
        ? themeProvider.darkTheme.primaryColor
        : const Color(0xFF700464);

    final textColor = themeProvider.darkMode
        ? Colors.white
        : Colors.white;

    return Scaffold(

      backgroundColor: const Color(0xFFeaeaea),
      appBar: AppBar (
        //backgroundColor: Color(0xFF700464),
        backgroundColor: appBarColor,
        title:   Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10.0),
            Text(
              'Notifications',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),

      body: Container(
        padding: const EdgeInsets.all(4.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: _adventuresStream,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                  User? user = FirebaseAuth.instance.currentUser;

                  if ( user  == null ) {
                    return  AlertDialog(
                      elevation: 10,
                      title: const Text('Login is Required'),
                      content: const Text("Please login to view your notifications"),
                      actions: <Widget>[
                       Container(
                          decoration:  const BoxDecoration(
                            color: Color(0xFF700464),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                         child: TextButton(
                           child:  const Text("Log In", textAlign: TextAlign.center, style:  TextStyle( color: Colors.white, fontWeight: FontWeight.bold , fontSize: 15 ) ) ,
                           onPressed: () {
                             _logout(context);
                           },
                         ),
                       )


                      ],
                    );
                      //const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 500,
                      child: Center(
                        child: CircularProgressIndicator(color: Color(0xFF700464),),
                      ),
                    );
                  }

                  if (snapshot.data == null || snapshot.data!.size == 0) {
                    return const SizedBox(
                      height: 500,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.cloud_sharp, color: Color(0xFF700464), size: 90),
                            SizedBox(width: 8.0),
                            Text('No adventures have been booked yet.'),
                          ],
                        ),
                      ),
                    );
                  }

                  // Extract the documents from the snapshot
                  final List<DocumentSnapshot> documents = snapshot.data?.docs ?? [];

                  // Convert the documents to a list of Map<String, dynamic>
                  List<Map<String, dynamic>> adventuresData = documents.map((doc) {
                    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                    // Convert 'adventureBookingDate' to DateTime
                    data['adventureBookingDate'] = (data['adventureBookingDate'] as Timestamp).toDate();
                    return data;
                  }).toList();

                  // Sort the list by 'adventureBookingDate' Z-A
                  adventuresData.sort((a, b) => b['adventureBookingDate'].compareTo(a['adventureBookingDate']));

                  return Column(
                    children: adventuresData.map((data) {
                 return ReusableCard(
                        adventureBookingDate: data['adventureBookingDate'] ?? '',
                        bookingStatus: data['bookingStatus'] ?? '',
                        adventureBookingID: data['adventureBookingID'] ?? '',
                        gender: data['gender'] ?? '',
                        age: data['age'] ?? '',
                        startDate: data['startDate'] ?? '',
                        endDate: data['endDate'] ?? '',
                        startTime: data['startTime'] ?? '',
                        endTime: data['endTime'] ?? '',
                        userID: data['userID'] ?? '',
                        serviceProviderName: data['serviceProviderName'] ?? '',
                        typeOfAdventure: data['typeOfAdventure'] ?? '',
                        phoneNumber: data['phoneNumber'] ?? '',
                        levelOfDifficulty: data['levelOfDifficulty'] ?? '',
                        adventureNature: data['adventureNature'] ?? '',
                        isFreeAdventure: data['isFreeAdventure'] ?? '',
                        isOnlyFamily: data['isOnlyFamily'] ?? '',
                        price: data['price'] ?? '',
                        maxNumberOfParticipants: data['maxNumberOfParticipants'] ?? '',
                        googleMapsLink: data['googleMapsLink '] ?? '',
                        adventureDescription: data['adventureDescription'] ?? '',
                        locationName: data['locationName'] ?? '',
                        bookedAdventureNumber: data['bookedAdventureNumber']  ?? '',
                      );
                    }).toList(),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}


class ReusableCard extends StatelessWidget {


  final DateTime adventureBookingDate;
  final String bookingStatus;
  final String adventureBookingID;
  final String bookedAdventureNumber;

  final String userID;
  final String serviceProviderName;
  final String typeOfAdventure;
  final String adventureDescription;
  final String phoneNumber;
  final String levelOfDifficulty;

  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;

  final String isOnlyFamily;
  final String adventureNature;
  final String age;
  final String gender;

  final String isFreeAdventure;
  final String price;
  final String maxNumberOfParticipants;
  final String googleMapsLink;
  final String locationName;

  const ReusableCard({super.key,

    required this.adventureBookingDate,
    required this.adventureBookingID,
    required this.bookedAdventureNumber,
    required this.bookingStatus,
    required this.userID,
    required this.serviceProviderName,
    required this.typeOfAdventure,
    required this.adventureDescription,
    required this.phoneNumber,
    required this.levelOfDifficulty,

    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,

    required this.isOnlyFamily,
    required this.adventureNature,
    required this.gender,
    required this.age,

    required this.isFreeAdventure,
    required this.price,
    required this.maxNumberOfParticipants,
    required this.googleMapsLink,
    required this.locationName,


  });

  @override
  Widget build(BuildContext context) {

    return GFCard(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.all(3.0),
      buttonBar: GFButtonBar(
        children: <Widget>[
          //icons
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.category, size: 20, color: Color(0xFF700464),),
              const SizedBox(width: 5.0),
              typeOfAdventure != "" ? Text(typeOfAdventure) : const Text(''),
              const Spacer(),
            ],
          ),

          const SizedBox(height: 10),
          //Text
          Align(
            alignment: Alignment.centerLeft,

            child: Text(
              serviceProviderName != "" || serviceProviderName.isEmpty ? serviceProviderName : '',
              textAlign: TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
            ),
          ),

          Row(

            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              const SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  locationName,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                ),
              ),



                const Spacer(),
                 Align(
                   alignment: Alignment.topRight,
                   child: ElevatedButton(
                     onPressed: () {
                       User? user = FirebaseAuth.instance.currentUser;
                       String userID = "";
                       if (user != null) {
                         userID = user.uid;
                      //   print('Current User ID: $userID');
                         // Navigate to Notification Details

                         Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) =>  NotificationsDetailsForm (

                             // ----- This Goes to the Next Screen for confirmation
                             adventureBookingDate : adventureBookingDate,
                             userID :userID,
                             adventureBookingID : adventureBookingID ,
                             bookedAdventureNumber : bookedAdventureNumber,

                             serviceProviderName  :serviceProviderName,
                             typeOfAdventure  :typeOfAdventure,
                             adventureDescription:adventureDescription,
                             phoneNumber:phoneNumber,
                             levelOfDifficulty :levelOfDifficulty,

                             startDate :startDate,
                             endDate:endDate,
                             startTime:startTime,
                             endTime:endTime,

                             isOnlyFamily:isOnlyFamily,
                             adventureNature:adventureNature,
                             age:age,
                             Gender:gender,

                             IsFreeAdventure:isFreeAdventure,
                             Price:price,
                             MaxNumberOfParticipants:maxNumberOfParticipants,
                             googleMapsLink:googleMapsLink,
                             LocationName: locationName,



                           )),
                         );
                       }




                     },
                     style: TextButton.styleFrom(
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(32.0),
                       ),
                       backgroundColor: const Color(0xFF700464),
                       shadowColor: Colors.black,
                     ),
                     child: const Text(
                       "View",
                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                     ),
                   ),
                 )
            ],
          ),
        ],
      ),
    );
  }
}



// Create a function to handle logout
Future<void> _logout(BuildContext context) async {
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
    if (kDebugMode) {
      print("Error during logout: $e");
    }
  }
}


// Function to clear cached user data
Future<void> _clearCachedUserData() async  {

  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.clear(); // Clear all cached data
    if (kDebugMode) {
      print("Cached user data cleared");
    }

  } catch (e) {
    if (kDebugMode) {
      print("Error clearing cached user data: $e");
    }
  }

}
