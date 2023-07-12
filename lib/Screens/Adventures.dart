import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
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
//import 'package:flutter_datetime_picker/src/datetime_picker_theme.dart';

class AdventuresContainerScreen extends StatefulWidget {
  @override
  _AdventuresContainerScreenState createState() =>
      _AdventuresContainerScreenState();
}

class _AdventuresContainerScreenState extends State<AdventuresContainerScreen> {
  late Stream<QuerySnapshot> _adventuresStream;
  late List<Map<String, dynamic>> _cachedAdventures = [];
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _adventuresStream = FirebaseFirestore.instance
        .collection('adventure')
        .orderBy('AdventureCreationDate', descending: true)
        .snapshots();

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _initPrefs();
        _prefs = prefs;

        final String? adventuresJson = prefs.getString('adventures');
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
      appBar: AppBar(
        title: const Text('OmanAdventure'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Container(
        padding: const EdgeInsets.all(2.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: _adventuresStream,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
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
                            Text('No adventures have been posted yet.'),
                          ],
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      // Convert Timestamp to DateTime
                      final Timestamp creationTimestamp = data['AdventureCreationDate'] as Timestamp;
                      final DateTime creationDate = creationTimestamp.toDate();

                      return ReusableCard(
                        AdventureCreationDate: creationDate,
                        gender: data['Gender'] ?? '',
                        age: data['Age '] ?? '',
                        StartDate: data['Start Date'] ?? '',
                        EndDate: data['End tDate'] ?? '',
                        StartTime: data['Start Time'] ?? '',
                        EndTime: data['End Time'] ?? '',
                        uuid: data['uuid'] ?? '',
                        adven_provider_Name: data['service_provider_Name'] ?? '',
                        count: data['count'] ?? '',
                        type_of_Adventure: data['Type of Adventure'] ?? '',
                        Phone_Number: data['Phone Number'] ?? '',
                        difficultyLevel: data['Level of Difficulty'] ?? '',
                        adventureNature: data['Adventure Nature '] ?? '',
                        freeAdventure: data['Is Free Adventure'] ?? '',
                        onlyFamilies: data['Is only family '] ?? '',
                        price: data['Price'] ?? '',
                        max_number_of_Participants: data['Max number of Participants'] ?? '',
                        googleMapsLink: data['googleMapsLink '] ?? '',
                        adventureDescription: data['Adventure Description'] ?? '',
                        locationName: data['The name of the location '] ?? '',
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


  final DateTime AdventureCreationDate;
  final String uuid;
  final String count;
  final String adven_provider_Name;
  final String type_of_Adventure;
  final String adventureDescription;
  final String Phone_Number;
  final String difficultyLevel;

  final String StartDate;
  final String EndDate;
  final String StartTime;
  final String EndTime;


  final String onlyFamilies;
  final String adventureNature;
  final String age;
  final String gender;

  final String freeAdventure;
  final String price;
  final String max_number_of_Participants;
  final String googleMapsLink;
  final String locationName;

  ReusableCard({

    required this.AdventureCreationDate,
    required this.uuid,
    required this.count,
    required this.adven_provider_Name,
    required this.type_of_Adventure,
    required this.adventureDescription,
    required this.Phone_Number,
    required this.difficultyLevel,

    required this.StartDate,
    required this.EndDate,
    required this.StartTime,
    required this.EndTime,

    required this.onlyFamilies,
    required this.adventureNature,
    required this.gender,
    required this.age,

    required this.freeAdventure,
    required this.price,
    required this.max_number_of_Participants,
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
               const Text('🐎', style: TextStyle(fontSize: 20)),
             //  const Icon(Icons.category_outlined, color: Colors.teal),
               const SizedBox(width: 5.0),
               type_of_Adventure != "" ? Text(type_of_Adventure) : Text(''),
               const Spacer(),
               age != "" ? Text(age) : Text(''),
             ],
           ),
           const SizedBox(height: 3),
           Row(
             crossAxisAlignment: CrossAxisAlignment.center,
             children: <Widget>[
               Icon(Icons.accessibility, color: Colors.teal),
               SizedBox(width: 5.0),
               difficultyLevel != "" ? Text(difficultyLevel) : Text(''),
               onlyFamilies != "" ? Text(onlyFamilies) : Text(''),
             ],
           ),
           Row(
             crossAxisAlignment: CrossAxisAlignment.center,
             children: <Widget>[
               Icon(Icons.group, color: Colors.teal),
               SizedBox(width: 5.0),
               adventureNature != "" ? Text(adventureNature) : Text(''),
               Spacer(),
               max_number_of_Participants != "" ? Text(max_number_of_Participants) : Text(''),
             ],
           ),
           Row(
             crossAxisAlignment: CrossAxisAlignment.center,
             children: <Widget>[
               Icon(Icons.group, color: Colors.teal),
               SizedBox(width: 5.0),
               Spacer(),
               gender != "" ? Text(gender) : Text(''),
             ],
           ),
           const SizedBox(height: 10),
           //Text
           Align(
             alignment: Alignment.centerLeft,
             //NameoftheHotel
             child: Text(
               adven_provider_Name != "" || adven_provider_Name.isEmpty ? adven_provider_Name : '',
               textAlign: TextAlign.left,
               style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
             ),
           ),
           const SizedBox(height: 10),
           //Text
           Align(
             alignment: Alignment.centerLeft,
             //NameoftheHotel
             child: Text(

               adventureDescription ?? '',
               textAlign: TextAlign.left,
               style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
             ),
           ),
           const SizedBox(height: 8),
           Row(
             mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               //StartDate
               Row(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: <Widget>[
                   Icon(Icons.calendar_month, color: Colors.teal),
                   SizedBox(width: 1.0),
                   Text(
                     "Starts on: ",
                     textAlign: TextAlign.left,
                     style: TextStyle(
                         fontWeight: FontWeight.normal,
                         fontSize: 16,
                         color: Colors.black54),
                   ),
                   Text(
                     StartDate ?? '',
                     textAlign: TextAlign.left,
                     style: TextStyle(
                         fontWeight: FontWeight.normal,
                         fontSize: 16,
                         color: Colors.black54),
                   ),
                 ],
               ),
               const Spacer(),
               Row(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: <Widget>[
                   Icon(Icons.watch_later, color: Colors.teal),
                   SizedBox(width: 1.0),
                   Text(
                     StartTime ?? '',
                     textAlign: TextAlign.left,
                     style: TextStyle(
                         fontWeight: FontWeight.normal,
                         fontSize: 16,
                         color: Colors.black54),
                   ),
                 ],
               ),
             ],
           ),



           Row(
//mainAxisAlignment:MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: <Widget>[
//StartDate
               Row(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: <Widget>[
                   Icon(
                     Icons.calendar_month,
                     color: Colors.teal,
                   ),
                   SizedBox(
                     width: 1.0,
                   ),
                   Text(
                     "End on:    ",
                     textAlign: TextAlign.left,
                     style: TextStyle(
                       fontWeight: FontWeight.normal,
                       fontSize: 16,
                       color: Colors.black54,
                     ),
                   ),
                   SizedBox(
                     width: 5.0,
                   ),
                   Text(
                    EndDate ?? '',
                     textAlign: TextAlign.left,
                     style: TextStyle(
                       fontWeight: FontWeight.normal,
                       fontSize: 16,
                       color: Colors.black54,
                     ),
                   ),
                 ],
               ),
               const Spacer(),
               Row(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children:   <Widget>[
                   Icon(
                     Icons.watch_later,
                     color: Colors.teal,
                   ),
                   SizedBox(
                     width: 1.0,
                   ),
                   Text(
                     EndTime ?? '',
                     textAlign: TextAlign.left,
                     style: TextStyle(
                       fontWeight: FontWeight.normal,
                       fontSize: 16,
                       color: Colors.black54,
                     ),
                   ),
                 ],
               ),
             ],
           ),
        /*
           Row(
             crossAxisAlignment: CrossAxisAlignment.center,
             children: <Widget>[
               Icon(
                 Icons.map,
                 color: Colors.teal,
               ),
             ],
           ),
*/
           const SizedBox(
             height: 8,
           ),


           Align(
             alignment: Alignment.centerLeft,
             //NameoftheHotel
             child: Text(
               locationName ?? '',
               textAlign: TextAlign.left,
               style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
             ),
           ),

           const SizedBox(
             height: 8,
           ),

           Row(
             crossAxisAlignment: CrossAxisAlignment.center,
             children: <Widget>[
               ElevatedButton(
                 onPressed: null,
                 style: TextButton.styleFrom(
                   backgroundColor: Colors.transparent,
                 ),
                 child: Text(
                   price ?? '',
                   textAlign: TextAlign.left,
                   style: const TextStyle(
                     fontWeight: FontWeight.normal,
                     fontSize: 16,
                     color: Colors.black54,
                   ),
                 ),
               ),
               const Spacer(),
               ElevatedButton(
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

               const Spacer(),

               ElevatedButton(
                 onPressed: () {
                   Navigator.of(context).restorablePush(_dialogBuilder);
                   print("Go to next page for signup");
                 },
                 style: TextButton.styleFrom(
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(32.0),
                   ),
                   backgroundColor: Colors.red,
                 ),
                 child: const Text(
                   "Let's do it",
                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                 ),
               ),

             ],
           ),




         ],
       ),


     );
  }



  static Route<Object?> _dialogBuilder(BuildContext context, Object? arguments) {
    return DialogRoute<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          scrollable: true, //<--Set it to true
          content: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
          Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextButton.icon(
            onPressed: null,
            icon: const Icon(Icons.tag_faces_outlined, color: Colors.red),
            label: const Text(
              "Login to start your adventure",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                color: Colors.teal,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SignInButton(
            Buttons.Email,
            text: "Signup with Email",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpScreen()),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SignInButtonBuilder(
            text: 'Sign In with Email',
            icon: Icons.email,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmailLogIn()),
              );
            },
            backgroundColor: Colors.teal,
            width: 220.0,
          ),
        ),

              ],
          ),
    ),
    );
  }





}