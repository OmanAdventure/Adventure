import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:untitled/Screens/NotificationDetails.dart';
import 'package:untitled/Screens/SplitScreensForm.dart';
import 'package:untitled/Screens/signup.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'email_login.dart';
import 'email_signup.dart';
import 'CustomerAdventureForm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'SettingsScreen.dart';

void main() => runApp(
    Notifications()
);

class Notifications extends StatelessWidget {
  Notifications();

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MyNotificationState(),
      ),
    );
  }
}

class MyNotificationState extends StatefulWidget {
  MyNotificationState({Key? key}) : super(key: key);
  @override
  State<MyNotificationState> createState() => _MyNotificationContainerState();
}

class _MyNotificationContainerState extends State<MyNotificationState> {
  late Stream<QuerySnapshot> _adventuresStream;
  late List<Map<String, dynamic>> _cachedAdventures = [];
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();

    User? user = FirebaseAuth.instance.currentUser;
    String userId = "";
    if (user != null) {
      userId = user.uid;

    }

    print('&^*&^*&^*&^*&^*&^*&^*&^*&^*&^*&^*&^*&^*&^*&^*&^*^*&^*&^*&^');
    print(userId);
    print('&^*&^*&^*&^*&^*&^*&^*&^*&^*&^*&^*&^*&^*&^*&^*&^*^*&^*&^*&^');

    _adventuresStream = FirebaseFirestore.instance
        .collection('BookedAdventure')
        .where("UserID", isEqualTo: userId )
    //  .orderBy('AdventureCreationDate', descending: true)
        .snapshots();

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
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFeaeaea),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: 10.0),
            Text(
              'Notifications',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
          ],
        ),



      ),
      body: Container(
        padding: const EdgeInsets.all(2.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: _adventuresStream,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                  User? user = FirebaseAuth.instance.currentUser;
print(user);
                  if (snapshot.hasError && user != null) {
                    return  AlertDialog(
                      title: const Text('Login is Required '),
                      content: const Text("Please login to view your notifications"),
                      actions: <Widget>[
                        TextButton(
                          // color: Colors.teal,
                          child:  const Text("OK", textAlign: TextAlign.center, style:  TextStyle(color: Colors.white) ) ,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                      //const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 500,
                      child: Center(
                        child: CircularProgressIndicator(),
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
                            Icon(Icons.cloud_sharp, color: Colors.teal, size: 90),
                            SizedBox(width: 8.0),
                            Text('No adventures have been booked yet.'),
                          ],
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      // Convert Timestamp to DateTime
                      print("Data received: $data"); // Add this line
                      final Timestamp creationTimestamp = data['AdventureBookingDate'] as Timestamp;
                      final DateTime AdventureBookingDate = creationTimestamp.toDate();

                      return ReusableCard(
                        AdventureBookingDate: AdventureBookingDate,
                        BookingStatus: data['BookingStatus'] ?? '',
                        AdventureBookingID: data['AdventureBookingID'] ?? '',
                        Gender: data['Gender'] ?? '',
                        Age: data['Age'] ?? '',
                        StartDate: data['StartDate'] ?? '',
                        EndDate: data['EndDate'] ?? '',
                        StartTime: data['StartTime'] ?? '',
                        EndTime: data['EndTime'] ?? '',
                        UserID: data['UserID'] ?? '',
                        ServiceProviderName: data['ServiceProviderName'] ?? '',
                        TypeOfAdventure: data['TypeOfAdventure'] ?? '',
                        Phone_Number: data['PhoneNumber'] ?? '',
                        LevelOfDifficulty: data['LevelOfDifficulty'] ?? '',
                        AdventureNature: data['AdventureNature'] ?? '',
                        IsFreeAdventure: data['IsFreeAdventure'] ?? '',
                        IsOnlyFamily: data['IsOnlyFamily'] ?? '',
                        Price: data['Price'] ?? '',
                        MaxNumberOfParticipants: data['MaxNumberOfParticipants'] ?? '',
                        googleMapsLink: data['googleMapsLink'] ?? '',
                        AdventureDescription: data['AdventureDescription'] ?? '',
                        LocationName: data['LocationName'] ?? '',
                        BookedAdventureNumber: 'BookedAdventureNumber',
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

  Map<String, dynamic> _convertDocumentToJson(DocumentSnapshot document) {
    final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    // Convert Timestamp to milliseconds since Unix epoch
    final Timestamp creationTimestamp = data['AdventureCreationDate'] as Timestamp;
    final int milliseconds = creationTimestamp.millisecondsSinceEpoch;
    data['AdventureCreationDate'] = milliseconds;
    return data;
  }
}


class ReusableCard extends StatelessWidget {


  final DateTime AdventureBookingDate;
  final String BookingStatus;
  final String AdventureBookingID;
  final String BookedAdventureNumber;

  final String UserID;
  final String ServiceProviderName;
  final String TypeOfAdventure;
  final String AdventureDescription;
  final String Phone_Number;
  final String LevelOfDifficulty;

  final String StartDate;
  final String EndDate;
  final String StartTime;
  final String EndTime;

  final String IsOnlyFamily;
  final String AdventureNature;
  final String Age;
  final String Gender;

  final String IsFreeAdventure;
  final String Price;
  final String MaxNumberOfParticipants;
  final String googleMapsLink;
  final String LocationName;

  ReusableCard({

    required this.AdventureBookingDate,
    required this.AdventureBookingID,
    required this.BookedAdventureNumber,
    required this.BookingStatus,
    required this.UserID,
    required this.ServiceProviderName,
    required this.TypeOfAdventure,
    required this.AdventureDescription,
    required this.Phone_Number,
    required this.LevelOfDifficulty,

    required this.StartDate,
    required this.EndDate,
    required this.StartTime,
    required this.EndTime,

    required this.IsOnlyFamily,
    required this.AdventureNature,
    required this.Gender,
    required this.Age,

    required this.IsFreeAdventure,
    required this.Price,
    required this.MaxNumberOfParticipants,
    required this.googleMapsLink,
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
          //icons
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text('🐎', style: TextStyle(fontSize: 20)),
              //  const Icon(Icons.category_outlined, color: Colors.teal),
              const SizedBox(width: 5.0),
              TypeOfAdventure != "" ? Text(TypeOfAdventure) : Text(''),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.accessibility, color: Colors.teal),
              SizedBox(width: 5.0),
              LevelOfDifficulty != "" ? Text(LevelOfDifficulty) : Text(''),
            ],
          ),

          const SizedBox(height: 10),
          //Text
          Align(
            alignment: Alignment.centerLeft,
            //NameoftheHotel
            child: Text(
              ServiceProviderName != "" || ServiceProviderName.isEmpty ? ServiceProviderName : '',
              textAlign: TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
            ),
          ),

          Row(
//mainAxisAlignment:MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              const SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.centerLeft,
                //NameoftheHotel
                child: Text(
                  LocationName ?? '',
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                ),
              ),



                Spacer(),
                 Align(
                   alignment: Alignment.topRight,
                   child: ElevatedButton(
                     onPressed: () {

                       User? user = FirebaseAuth.instance.currentUser;
                       String userId = "";
                       if (user != null) {
                         userId = user.uid;
                         print('Current User ID: $userId');
                         // Navigate to Notification Details

                         Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) =>  NotificationsDetailsForm(

                             // ----- This Goes to the Next Screen for confirmation
                             AdventureBookingDate : AdventureBookingDate,
                             UserID :UserID,
                             AdventureBookingID : AdventureBookingID ,
                             BookedAdventureNumber : BookedAdventureNumber,

                             ServiceProviderName  :ServiceProviderName,
                             TypeOfAdventure  :TypeOfAdventure,
                             AdventureDescription:AdventureDescription,
                             Phone_Number:Phone_Number,
                             LevelOfDifficulty :LevelOfDifficulty,

                             StartDate :StartDate,
                             EndDate:EndDate,
                             StartTime:StartTime,
                             EndTime:EndTime,

                             IsOnlyFamily:IsOnlyFamily,
                             AdventureNature:AdventureNature,
                             Age:Age,
                             Gender:Gender,

                             IsFreeAdventure:IsFreeAdventure,
                             Price:Price,
                             MaxNumberOfParticipants:MaxNumberOfParticipants,
                             googleMapsLink:googleMapsLink,
                             LocationName: LocationName,



                           )),
                         );
                       }


                       //    Navigator.of(context).restorablePush(_dialogBuilder);

                     },
                     style: TextButton.styleFrom(
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(32.0),
                       ),
                       backgroundColor: Colors.red,
                     ),
                     child: const Text(
                       "View",
                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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