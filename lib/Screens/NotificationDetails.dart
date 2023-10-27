import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationsDetailsForm extends StatefulWidget {

  final DateTime AdventureBookingDate ;
  final String UserID;
  final String AdventureBookingID;
  final String BookedAdventureNumber;

  final String  ServiceProviderName ;
  final String TypeOfAdventure ;
  final String AdventureDescription;
  final String Phone_Number;
  final String LevelOfDifficulty ;

  final String StartDate ;
  final String EndDate;
  final String StartTime;
  final String EndTime;

  final String IsOnlyFamily;
  final String AdventureNature;
  final String Age;
  final String Gender;

  final String IsFreeAdventure;
  final String Price;
  final String  MaxNumberOfParticipants;
  final String googleMapsLink;
  final String LocationName;

  const NotificationsDetailsForm({Key? key,

    required this.AdventureBookingDate,
    required this.UserID,
    required this.AdventureBookingID,
    required this.BookedAdventureNumber,

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

    required this.Age,
    required this.Gender,
    required this.IsFreeAdventure,
    required this.Price,
    required this.MaxNumberOfParticipants,
    required this.googleMapsLink,
    required this.LocationName,

   }) : super(key: key);

  @override
  NotificationsDeatilsState createState() => NotificationsDeatilsState(

    AdventureBookingDate : AdventureBookingDate,
    UserID :UserID,
    AdventureBookingID : AdventureBookingID ,
    BookedAdventureNumber: BookedAdventureNumber,

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
    BookingStatus: '',




  );
}


class NotificationsDeatilsState extends State<NotificationsDetailsForm> {


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

  NotificationsDeatilsState({

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

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: Text(
          'Notifications Details',
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
                          ServiceProviderName,
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: ListTile(
                        leading: Icon(Icons.category),
                        title: Text(
                            TypeOfAdventure
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: ListTile(
                        leading: Icon(Icons.description),
                        title: Text(
                            AdventureDescription
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
                      child: ListTile(
                        leading: Icon(Icons.local_activity),
                        title: Text(
                            LevelOfDifficulty
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
                        StartDate,
                      ),
                      trailing: Text(
                        EndDate,
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
                        StartTime,
                      ),
                      trailing: Text(
                        EndTime,
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
                        AdventureNature,
                      ),
                      trailing: Text(
                        IsOnlyFamily,
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
                        Age,
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

            // Button

          ],
        ),
      ),
    );
  }

}
