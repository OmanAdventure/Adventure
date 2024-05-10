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
import 'package:flutter/cupertino.dart';

import 'CustomerAdventureForm.dart';
import 'FavoriteAdventuresDetails.dart';

enum Sky { booked, favorite }

//enum Sky { booked, shared, favorite }

Map<Sky, Color> skyColors = <Sky, Color>{
  Sky.booked: const Color(0xFF700464),
 // Sky.shared: const Color(0xFF700464),
  Sky.favorite: const Color(0xFF700464),
};

void main() {
  runApp(
      const MaterialApp(
        home: MyBookedAdventuresState(),
      )
  );
}

class SegmentedControlApp extends StatelessWidget {
  const SegmentedControlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(brightness: Brightness.light),
    );
  }
}

class MyBookedAdventuresState extends StatefulWidget {
  const MyBookedAdventuresState({Key? key}) : super(key: key);

  @override
  State<MyBookedAdventuresState> createState() => _MyAdventuresContainerState();
}

class _MyAdventuresContainerState extends State<MyBookedAdventuresState> {

  // Stream for Booked Adventures
  late Stream<QuerySnapshot> _adventuresStream;
  // Stream for favorite Adventures
  late Stream<QuerySnapshot> _favoriteadventuresStream;
  // Stream for shared with me Adventures
 // late Stream<QuerySnapshot> _sharedadventuresStream;

  Sky _selectedSegment = Sky.booked;

  @override
  void initState() {
    super.initState();

    User? user = FirebaseAuth.instance.currentUser;
    String userID = "";
    if (user != null) {
      userID = user.uid;
    }

    _adventuresStream = FirebaseFirestore.instance
        .collection('BookedAdventure')
        .where("userID", isEqualTo: userID)
        //.orderBy('adventureBookingDate', descending: true)
        .snapshots();

    _favoriteadventuresStream = FirebaseFirestore.instance
        .collection("user-favorite-items")
        .doc(FirebaseAuth.instance.currentUser !. uid)
        .collection("favorite-items").snapshots();


  }

  Widget _segmentContainer() {
    if (_selectedSegment.index == 0) {
      // Display the Container when segment is 0
      return Container(
        padding: const EdgeInsets.all(2.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: _adventuresStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 500,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF700464),
                        ),
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
                            Icon(Icons.cloud_sharp,
                                color: Color(0xFF700464), size: 90),
                            SizedBox(width: 8.0),
                            Text('No adventures have been booked yet.'),
                          ],
                        ),
                      ),
                    );
                  }
                  // Extract the documents from the snapshot
                  final List<DocumentSnapshot> documents =
                      snapshot.data?.docs ?? [];
                  // Convert the documents to a list of Map<String, dynamic>
                  List<Map<String, dynamic>> adventuresData =
                      documents.map((doc) {
                    final Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    // Convert 'adventureBookingDate' to DateTime
                    data['adventureBookingDate'] =
                        (data['adventureBookingDate'] as Timestamp).toDate();
                    return data;
                  }).toList();

                  // Sort the list by 'adventureBookingDate' Z-A
                  adventuresData.sort((a, b) => b['adventureBookingDate']
                      .compareTo(a['adventureBookingDate']));

                  return Column(
                    children: adventuresData.map((data) {
                      return ReusableCard(
                        adventureBookingDate: data['adventureBookingDate'] ?? '',
                        bookingStatus: data['bookingStatus'] ?? '',
                        adventureBookingID: data['adventureBookingID'] ?? '',
                        serviceProviderName: data['serviceProviderName'] ?? '',
                        typeOfAdventure: data['typeOfAdventure'] ?? '',
                        bookedAdventureNumber: data['bookedAdventureNumber'] ?? '',
                        userID: data['userID'] ?? '',
                         LocationName: data['locationName']
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    if (_selectedSegment.index == 1) {
      // Display the Container when segment is 0
      return Container(
        padding: const EdgeInsets.all(2.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: _favoriteadventuresStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 500,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF700464),
                        ),
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
                            Icon(Icons.cloud_sharp,
                                color: Color(0xFF700464), size: 90),
                            SizedBox(width: 8.0),
                            Text('No adventures added to your favorite List.'),
                          ],
                        ),
                      ),
                    );
                  }
                  // Extract the documents from the snapshot
                  final List<DocumentSnapshot> documents =
                      snapshot.data?.docs ?? [];
                  // Convert the documents to a list of Map<String, dynamic>
                  List<Map<String, dynamic>> favoriteAdventuresData =
                  documents.map((doc) {
                    final Map<String, dynamic> data =
                    doc.data() as Map<String, dynamic>;
                    // Convert 'AdventureAddedDate' to DateTime
                    data['adventureAddedDate'] =
                        (data['adventureAddedDate'] as Timestamp).toDate();
                    return data;
                  }).toList();

                  // Sort the list by 'AdventureAddedDate' Z-A
                  favoriteAdventuresData.sort((a, b) => b['adventureAddedDate']
                      .compareTo(a['adventureAddedDate']));

                  return Column(
                    children: favoriteAdventuresData.map((data) {
                      return FavoriteReusableCard(
                         AdventureAddedDate: data['adventureAddedDate'] ?? '',
                        // adventureBookingID: data['adventureBookingID'] ?? '',
                        adventureProviderName: data['serviceProviderName'] ?? '',
                        typeOfAdventure: data['typeOfAdventure'] ?? '',
                        userID: data['userID'] ?? '',
                        locationName: data['locationName'],
                        adventureID:  data['adventureID'],
                        adventureDescription: data['adventureDescription'],
                        phoneNumber: data['phoneNumber'],
                        difficultyLevel: data['levelOfDifficulty'],
                        startDate: data['startDate'],
                        endDate: data['endDate'],
                        startTime: data['startTime'],
                        endTime: data['endTime'],
                        onlyFamilies: data['isOnlyFamily'],
                        adventureNature: data['isFreeAdventure'],
                        gender: data['gender'],
                        age: data['age'],
                        freeAdventure: data['isFreeAdventure'],
                        price: data['price'],
                        maxNumberOfParticipants: data['maxNumberOfParticipants'],
                        googleMapsLink: data['googleMapsLink'],
                        images: data['imageUrls'],



                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }
    // Return an empty Container if _selectedSegment is not 0
    return Container();
  }

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    final appBarColor = themeProvider.darkMode
        ? themeProvider.darkTheme.primaryColor
        : const Color(0xFF700464);
    final textColor = themeProvider.darkMode ? Colors.white : Colors.white;

    return Scaffold(
      backgroundColor: const Color(0xFFeaeaea),
      appBar: AppBar(
        backgroundColor: appBarColor,
        title:   Text("My Adventures",
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.normal,
            color: textColor,
            //color: textColor,
          ),
         ),
        centerTitle: true,
      ),
      body: CupertinoPageScaffold(
       backgroundColor: const Color(0xFFeaeaea),

        navigationBar: CupertinoNavigationBar(
          backgroundColor: const Color(0xFF700464),
          automaticallyImplyLeading: false, // Set this to false to hide the back button
          middle: CupertinoSlidingSegmentedControl<Sky>(
            backgroundColor: CupertinoColors.systemGrey2,
            thumbColor: skyColors[_selectedSegment]!,
            // This represents the currently selected segmented control.
            groupValue: _selectedSegment,
            // Callback that sets the selected segmented control.
            onValueChanged: (Sky? value) {
              if (value != null) {
                setState(() {
                  _selectedSegment = value;
                });
              }
            },
            children: const <Sky, Widget>{
              Sky.booked: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Booked',
                  style: TextStyle(color: CupertinoColors.white),
                ),
              ),
              /*
              Sky.shared: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Shared',
                  style: TextStyle(color: CupertinoColors.white),
                ),
              ),
              */
              Sky.favorite: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Favorite',
                  style: TextStyle(color: CupertinoColors.white),
                ),
              ),
            },
          ),
        ),

        child: SingleChildScrollView(
          padding: const EdgeInsets.all(4.0),
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
             _segmentContainer(),
          ],
        ),
        )
      ),
    );
  }
}

// This Reusable card used for showing my booked adventures
class ReusableCard extends StatelessWidget {
  final DateTime adventureBookingDate;
  final String bookingStatus;
  final String adventureBookingID;
  final String bookedAdventureNumber;
  final String userID;
  final String serviceProviderName;
  final String typeOfAdventure;
  final String LocationName;

  const ReusableCard({
    super.key,
    required this.adventureBookingDate,
    required this.adventureBookingID,
    required this.bookedAdventureNumber,
    required this.bookingStatus,
    required this.userID,
    required this.serviceProviderName,
    required this.typeOfAdventure,
    required this.LocationName,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.category,
                size: 20,
                color: Color(0xFF700464),
              ),
              //  const Icon(Icons.category_outlined, color: Color(0xFF700464)),
              const SizedBox(width: 5.0),
              typeOfAdventure != "" ? Text(typeOfAdventure) : const Text(''),
              const Spacer(),
                Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Icon(Icons.done, color: Colors.green),
                  SizedBox(width: 5.0),
                  bookingStatus != "" ? Text(bookingStatus) : const Text(''),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              serviceProviderName != "" || serviceProviderName.isEmpty
                  ? serviceProviderName
                  : '',
              textAlign: TextAlign.left,
              style:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 8,
              ),
              const Icon(
                Icons.location_on_sharp,
                size: 20,
                color: Color(0xFF700464),
              ),
              //  const Icon(Icons.category_outlined, color: Color(0xFF700464)),
              const SizedBox(width: 5.0),
              LocationName != "" ? Text(LocationName) : const Text(''),

              const Spacer(),
              /*
              Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  onPressed: () {
                    User? user = FirebaseAuth.instance.currentUser;
                    String userID = "";
                    if (user != null) {
                      userID = user.uid;

                      print("object");
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
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.white),
                  ),
                ),
              ),
              */
            ],
          ),
        ],
      ),
    );
  }
}

// This Reusable card used for showing my favorite adventures
class FavoriteReusableCard extends StatelessWidget {
   final DateTime? AdventureAddedDate;
  final String adventureID;

  final String userID;
  final String adventureProviderName;
  final String typeOfAdventure;
  final String locationName;

  final String adventureDescription;
  final String phoneNumber;
  final String difficultyLevel;
  final String startDate;
  final String endDate;
  final String  startTime;
  final String  endTime;

  final String onlyFamilies;
  final String adventureNature;
  final String gender;
  final String  age;

  final String  freeAdventure;
  final String  price;
  final String  maxNumberOfParticipants;
  final String  googleMapsLink;
  final List images;

  const FavoriteReusableCard({
    super.key,
    required this.AdventureAddedDate,

    required this.userID,
    required this.adventureProviderName,
    required this.typeOfAdventure,
    required this.locationName,
    required this.adventureID,

    required this.adventureDescription,
    required this.phoneNumber,
    required this.difficultyLevel,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,

    required this.onlyFamilies,
    required this.adventureNature,
    required this.gender,
    required this.age,

    required this.freeAdventure,
    required this.price,
    required this.maxNumberOfParticipants,
    required this.googleMapsLink,
    required this.images

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.category,
                size: 20,
                color: Color(0xFF700464),
              ),
              //  const Icon(Icons.category_outlined, color: Color(0xFF700464)),
              const SizedBox(width: 5.0),
              typeOfAdventure != "" ? Text(typeOfAdventure) : const Text(''),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              adventureProviderName != "" || adventureProviderName.isEmpty
                  ? adventureProviderName
                  : '',
              textAlign: TextAlign.left,
              style:
              const TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.location_on_sharp,
                size: 20,
                color: Color(0xFF700464),
              ),
              //  const Icon(Icons.category_outlined, color: Color(0xFF700464)),
              const SizedBox(width: 5.0),
              locationName != "" ? Text(locationName) : const Text(''),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  User? user = FirebaseAuth.instance.currentUser;
                  String userID = "";


                  if (user != null ) {
                    userID = user.uid;
                    if (kDebugMode) {
                      print('Current User ID: $userID');
                    }
                    // Navigate to My Custom Form

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FavoriteAdventuresDetails(
                          // ----- This Goes to the Next Screen for confirmation
                          AdventureAddedDate : AdventureAddedDate,
                          adventureID : adventureID,
                          adventureProviderName  :adventureProviderName,
                          typeOfAdventure  :typeOfAdventure,
                          adventureDescription:adventureDescription,
                          phoneNumber:phoneNumber,
                          difficultyLevel :difficultyLevel,

                          startDate : startDate,
                          endDate: endDate,
                          startTime:startTime,
                          endTime:endTime,

                          onlyFamilies:onlyFamilies,
                          adventureNature:adventureNature,
                          age:age,
                          gender:gender,

                          freeAdventure:freeAdventure,
                          price:price,
                          maxNumberOfParticipants: maxNumberOfParticipants ,
                          googleMapsLink:googleMapsLink,
                          locationName:locationName,
                          images : images,

                        ),
                      ),
                    );
                  }
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    side: const BorderSide(color:  Colors.white,),
                  ),
                  backgroundColor:  Color(0xFF700464),
                  elevation: 5,
                ),
                child: const Text(
                  "View",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
