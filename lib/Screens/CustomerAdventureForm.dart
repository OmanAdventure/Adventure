//import 'dart:ffi';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/Screens/form_completed.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {

  final DateTime AdventureCreationDate ;
  final String uuid;
  final String AdventureID;
  final String count  ;
  final String  adven_provider_Name ;
  final String type_of_Adventure ;
  final String adventureDescription;
  final String Phone_Number;
  final String difficultyLevel ;

  final String StartDate ;
  final String EndDate;
  final String StartTime;
  final String EndTime;

  final String onlyFamilies;
  final String adventureNature;
  final String age;
  final String gender;

  final String freeAdventure;
  final String price;
  final String  max_number_of_Participants;
  final String googleMapsLink;
  final String locationName;


  const MyCustomForm({Key? key,

    required this.AdventureCreationDate,
    required this.AdventureID,
    required this.uuid,
    required this.count,
    required this.adven_provider_Name,
    required this.adventureDescription,
    required this.Phone_Number,
    required this.difficultyLevel,
    required this.StartDate,
    required this.EndDate,
    required this.StartTime,
    required this.EndTime,
    required this.onlyFamilies,
    required this.adventureNature,
    required this.age,
    required this.gender,
    required this.freeAdventure,
    required this.price,
    required this.max_number_of_Participants,
    required this.googleMapsLink,
    required this.locationName,
    required this.type_of_Adventure,
    }) : super(key: key);

  @override
  MyCustomFormState createState() => MyCustomFormState(


    AdventureCreationDate : AdventureCreationDate,
    AdventureID : AdventureID,
    uuid :uuid,
    count    :count,
    advenProviderName  : adven_provider_Name,
    typeOfAdventure  :type_of_Adventure,
    adventureDescription:adventureDescription,
    phoneNumber:Phone_Number,
    difficultyLevel :difficultyLevel,

    startDate :StartDate,
    endDate:EndDate,
    startTime:StartTime,
    endTime: EndTime,

    onlyFamilies:onlyFamilies,
    adventureNature:adventureNature,
    age:age,
    gender:gender,

    freeAdventure:freeAdventure,
    price:price,
    maxNumberOfParticipants:max_number_of_Participants,
    googleMapsLink:googleMapsLink,
    locationName:locationName,

  );
}

// Define a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {

  bool _isSubmitting = false;

  //  Screen Content is displayed from here

  final  DateTime AdventureCreationDate  ;
  final String AdventureID;
  final String uuid ;
  final String count ;
  final String advenProviderName ;
  final String typeOfAdventure  ;
  final String adventureDescription;
  final String phoneNumber ;
  final String difficultyLevel;
  final String startDate ;
  final String endDate ;
  final String startTime;
  final String endTime ;
  final String onlyFamilies ;
  final String adventureNature;
  final  String age ;
  final String gender ;
  final String freeAdventure ;
  final String price ;
  final  String maxNumberOfParticipants;
  final String googleMapsLink;
  final String locationName ;


  MyCustomFormState({

    required this.AdventureCreationDate,
    required this.AdventureID,
    required this.uuid,
    required this.count,
    required this.advenProviderName,
    required this.typeOfAdventure,
    required this.adventureDescription,
    required this.phoneNumber,
    required this.difficultyLevel,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.onlyFamilies,
    required this.adventureNature,
    required this.age,
    required this.gender,
    required this.freeAdventure,
    required this.price,
    required this.maxNumberOfParticipants,
    required this.googleMapsLink,
    required this.locationName,

  });

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: Text(
          'Adventure Confirmation',
          style: GoogleFonts.satisfy(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
           // First Container
           Container(
              margin: EdgeInsets.fromLTRB(10, 2, 10, 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: ListTile(
                        leading: Icon(Icons.local_activity),
                        title: Text(
                          advenProviderName,
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: ListTile(
                        leading: Icon(Icons.category),
                        title: Text(
                            typeOfAdventure
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: ListTile(
                        leading: Icon(Icons.description),
                        title: Text(
                            adventureDescription
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
                      child: ListTile(
                        leading: Icon(Icons.local_activity),
                        title: Text(
                            difficultyLevel
                        ),
                      ),
                    ),
                  ]
              ),
            ),

            // Second Container
            Container(
              margin: EdgeInsets.fromLTRB(10, 2, 10, 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                  children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.date_range),
                            title: Text(
                              startDate,
                            ),
                            trailing: Text(
                              endDate,
                            ),
                          ),
                  ]
              ),
            ),

          // Third Container
            Container(
              margin: EdgeInsets.fromLTRB(10, 2, 10, 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.access_time_filled_rounded),
                      title: Text(
                          startTime,
                      ),
                      trailing: Text(
                          endTime,
                      ),
                    ),
                  ]
              ),
            ),

            // Fourth Container
            Container(
              margin: EdgeInsets.fromLTRB(10, 2, 10, 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.monetization_on),
                      title: Text(
                        price,
                      ),
                      trailing: Text(
                          freeAdventure,
                      ),
                    ),
                  ]
              ),
            ),

            // Fifth Container
            Container(
              margin: EdgeInsets.fromLTRB(10, 2, 10, 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.group),
                      title: Text(
                          adventureNature,
                      ),
                      trailing: Text(
                          onlyFamilies,
                      ),
                    ),
                  ]
              ),
            ),

            // Sixth Container
            Container(
              margin: EdgeInsets.fromLTRB(10, 2, 10, 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.group),
                      title: Text(
                        age,
                      ),
                      trailing: Text(
                        gender,
                      ),
                    ),
                  ]
              ),
            ),

            // Seventh Container
            Container(
              margin: EdgeInsets.fromLTRB(10, 2, 10, 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),

              child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.group),
                      title: const Text(
                          "Number of Participants:"
                      ),
                      trailing: Text(
                          maxNumberOfParticipants
                      ),
                    ),
                  ]
              ),

            ),

            // 8th Container
            Container(
              margin: EdgeInsets.fromLTRB(10, 2, 10, 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.group),
                      title: Text(
                        locationName,
                      ),
                      trailing:     ElevatedButton(
                        onPressed: () {
                          final snackBar = SnackBar(
                            content: const Text('Do you want to open the location in Google Maps?'),
                            action: SnackBarAction(
                              label: 'Open',
                              onPressed: () async {
                                final url = Uri.parse( googleMapsLink );
                                print(url);
                                if (await canLaunch(url.toString())) {
                                  await launch(url.toString());
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        child: const Icon(Icons.location_on_outlined, size: 30, color: Colors.teal),
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9.0),
                          ),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ]
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
              child: SizedBox(
                width: 400, // Set the width to match the button's width
                height: 50, // Set the height to match the button's height
                child: Stack(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all<TextStyle>(
                          const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(Size(400, 50)),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
                      ),
                      onPressed: () {
                        int convertedMaxNumberOfParticipants = int.tryParse(maxNumberOfParticipants) ?? 0;
                        // If maxNumberOfParticipants is 0, disable the button
                        if (convertedMaxNumberOfParticipants != 0) {
                          _confirmAdventure();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FormCompleted()),
                          );
                        } else {
                          maxNumberOfParticipants == 0 ? null :  _confirmAdventure();
                        }
                      },
                      child: const Text('Submit'),
                    ),
                    if (int.tryParse(maxNumberOfParticipants) == 0)
                      Container(
                        color: Colors.yellow, // Change to the desired color for the disabled button
                        child: const Center (
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                            child: Text(
                              'This adventure is fully booked',
                              style: TextStyle(color: Colors.red), // Customize text style
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            )




          ],
        ),
      ),
    );
  }

// ---------------------- To Firebase ----------------------

  Future<void> _confirmAdventure() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      // Generate a UUID
      final uuid = Uuid().v4();
      final adventureID = AdventureID;
      User? user = FirebaseAuth.instance.currentUser;
      String userId = "";
      userId = user!.uid;

      // Increment the adventure count
      final doc = await FirebaseFirestore.instance.collection('booked_adventure_count').doc('count').get();
      final count = doc.exists ? doc.data()!['count'] as int : 0;
      await FirebaseFirestore.instance.collection('booked_adventure_count').doc('count').set({'count': count + 1});

// -----------------Try updating the Max number of participants ----------------
      print('my adventure ID is');
      print(adventureID);
    // Update the document with the specified AdventureID
      final getAdv = await FirebaseFirestore.instance.collection('adventure')
          .where("AdventureID", isEqualTo: adventureID)
          .where("MaxNumberOfParticipants", isEqualTo: maxNumberOfParticipants)
          .get();


      if (getAdv.docs.isNotEmpty) {
        // Assuming you want to update only the first matching document.
        final documentSnapshot = getAdv.docs.first;
        final data = documentSnapshot.data();

        int currentMaxParticipants = int.tryParse(data['MaxNumberOfParticipants'] ?? '0') ?? 0;
        print('my MaxNumberOfParticipants is');
        print(currentMaxParticipants);

        if (currentMaxParticipants > 0) {
          // after booking decrement one
          currentMaxParticipants--;
          // Update the MaxNumberOfParticipants
          await documentSnapshot.reference.update({'MaxNumberOfParticipants': currentMaxParticipants.toString()});

          print('Partic After Decremented is');
          print(currentMaxParticipants);

        } else {
          print('MaxNumberOfParticipants is already at its minimum.');
        }
      } else {
        print('No adventure found with the given AdventureID and MaxNumberOfParticipants.');
      }





// ---------------------------------------------------------


      // Add the adventure data to Firestore with the UUID and count
      final bookedAdventureData = {

        'AdventureBookingDate': DateTime.now(),
        'BookingStatus' : 'Booked',
        'AdventureBookingID': uuid, // add the UUID to the map
        'BookedAdventureNumber': count + 1,
        'UserID': userId,
        'ServiceProviderName': advenProviderName,
        'TypeOfAdventure': typeOfAdventure ,
        'AdventureDescription': adventureDescription,
        'PhoneNumber':phoneNumber,
        'LevelOfDifficulty' : difficultyLevel ,

        'StartDate' : startDate,
        'EndDate': endDate,
        'StartTime':  startTime,
        'EndTime': endTime,

        'IsOnlyFamily' : onlyFamilies,
        'AdventureNature' :  adventureNature,
        'Gender' : gender ,
        'Age' : age ,

        "IsFreeAdventure" : freeAdventure,
        'Price' : price,
        'MaxNumberOfParticipants' :  maxNumberOfParticipants,

        'googleMapsLink ': googleMapsLink ,
        'LocationName': locationName ,

      };
      await FirebaseFirestore.instance
          .collection('BookedAdventure')
          .add(bookedAdventureData);
     // ScaffoldMessenger.of(context).showSnackBar(
     //     const SnackBar(content: Text('Your Adventure Booked Successfully')));

      setState(() {
        _isSubmitting = false;
      });
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
      setState(() {
        _isSubmitting = false;
      });
    }
  }




}



