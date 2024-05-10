import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../main.dart';

class NotificationsDetailsForm extends StatefulWidget {

  final DateTime adventureBookingDate ;
  final String userID;
  final String adventureBookingID;
  final String bookedAdventureNumber;

  final String  serviceProviderName ;
  final String typeOfAdventure ;
  final String adventureDescription;
  final String phoneNumber;
  final String levelOfDifficulty ;

  final String startDate ;
  final String endDate;
  final String startTime;
  final String endTime;

  final String isOnlyFamily;
  final String adventureNature;
  final String age;
  final String Gender;

  final String IsFreeAdventure;
  final String Price;
  final String  MaxNumberOfParticipants;
  final String googleMapsLink;
  final String LocationName;

  const NotificationsDetailsForm({Key? key,

    required this.adventureBookingDate,
    required this.userID,
    required this.adventureBookingID,
    required this.bookedAdventureNumber,

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

    required this.age,
    required this.Gender,
    required this.IsFreeAdventure,
    required this.Price,
    required this.MaxNumberOfParticipants,
    required this.googleMapsLink,
    required this.LocationName,

   }) : super(key: key);

  @override
  NotificationsDeatilsState createState() => NotificationsDeatilsState(

    adventureBookingDate : adventureBookingDate,
    userID :userID,
    adventureBookingID : adventureBookingID ,
    bookedAdventureNumber: bookedAdventureNumber,

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
    Gender:Gender,

    IsFreeAdventure:IsFreeAdventure,
    Price:Price,
    MaxNumberOfParticipants:MaxNumberOfParticipants,
    googleMapsLink:googleMapsLink,
    LocationName: LocationName,
    bookingStatus: '',




  );
}


class NotificationsDeatilsState extends State<NotificationsDetailsForm> {


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
  final String Gender;

  final String IsFreeAdventure;
  final String Price;
  final String MaxNumberOfParticipants;
  final String googleMapsLink;
  final String LocationName;

  NotificationsDeatilsState({

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
    required this.Gender,
    required this.age,

    required this.IsFreeAdventure,
    required this.Price,
    required this.MaxNumberOfParticipants,
    required this.googleMapsLink,
    required this.LocationName,


  });

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    final appBarColor = themeProvider.darkMode
        ? themeProvider.darkTheme.primaryColor
        : Color(0xFF700464);
    final textColor = themeProvider.darkMode
        ? Colors.white
        : Colors.white;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
       // backgroundColor: Color(0xFF700464),
        backgroundColor: appBarColor,
        title:   Text(
          'Notifications Details',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
              color: textColor,


          )
          /*
          style: GoogleFonts.satisfy(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
            color: Colors.white,
          ),
          */
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
                          serviceProviderName,
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
                            levelOfDifficulty
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
                        Price,
                      ),
                      trailing: Text(
                        IsFreeAdventure,
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
                        isOnlyFamily,
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
                        Gender,
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
                          MaxNumberOfParticipants
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
                        LocationName,
                      ),
                      trailing:  ElevatedButton(
                        onPressed: () {
                          print(googleMapsLink);
                          print(googleMapsLink);
                          print(googleMapsLink);
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
                        child: const Icon(Icons.location_on_outlined, size: 30, color: Color(0xFF700464)),
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

            // Button

          ],
        ),
      ),
    );
  }

}
