import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:getwidget/getwidget.dart';
import 'package:untitled/Screens/NotificationDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:untitled/Screens/signup.dart';

void main() => runApp(
    const Notifications()
);

class Notifications extends StatelessWidget {
  const Notifications();

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
    String userId = "";
    if (user != null) {
      userId = user.uid;
    }

    _adventuresStream = FirebaseFirestore.instance
        .collection('BookedAdventure').where("UserID", isEqualTo: userId )
        //.orderBy('AdventureBookingDate', descending: true)
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
    print("Notification Message");
    print(message);


    return Scaffold(
      backgroundColor: const Color(0xFFeaeaea),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

                  if ( user  == null ) {
                    return  AlertDialog(
                      title: const Text('Login is Required'),
                      content: const Text("Please login to view your notifications"),
                      actions: <Widget>[

                        TextButton(
                          child:  const Text("Log In", textAlign: TextAlign.center, style:  TextStyle( color: Colors.teal, fontWeight: FontWeight.bold , fontSize: 15 ) ) ,
                          onPressed: () {
                            _logout(context);
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

                  // Extract the documents from the snapshot
                  final List<DocumentSnapshot> documents = snapshot.data?.docs ?? [];

                  // Convert the documents to a list of Map<String, dynamic>
                  List<Map<String, dynamic>> adventuresData = documents.map((doc) {
                    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                    // Convert 'AdventureBookingDate' to DateTime
                    data['AdventureBookingDate'] = (data['AdventureBookingDate'] as Timestamp).toDate();
                    return data;
                  }).toList();

                  // Sort the list by 'AdventureBookingDate' Z-A
                  adventuresData.sort((a, b) => b['AdventureBookingDate'].compareTo(a['AdventureBookingDate']));

                  return Column(
                    children: adventuresData.map((data) {
                   // print("Data received: $data");


                      return ReusableCard(
                        AdventureBookingDate: data['AdventureBookingDate'] ?? '',
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
                        googleMapsLink: data['googleMapsLink '] ?? '',
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

  const ReusableCard({

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
              const Icon(Icons.category, size: 20, color: Colors.teal,),
              //  const Icon(Icons.category_outlined, color: Colors.teal),
              const SizedBox(width: 5.0),
              TypeOfAdventure != "" ? Text(TypeOfAdventure) : const Text(''),
              const Spacer(),
            ],
          ),

     /*
          const SizedBox(height: 3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.accessibility, color: Colors.teal),
              const SizedBox(width: 5.0),
              LevelOfDifficulty != "" ? Text(LevelOfDifficulty) : const Text(''),
            ],
          ),
*/
          const SizedBox(height: 10),
          //Text
          Align(
            alignment: Alignment.centerLeft,

            child: Text(
              ServiceProviderName != "" || ServiceProviderName.isEmpty ? ServiceProviderName : '',
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
                  LocationName ?? '',
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
                       String userId = "";
                       if (user != null) {
                         userId = user.uid;
                      //   print('Current User ID: $userId');
                         // Navigate to Notification Details

                         Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) =>  NotificationsDetailsForm (

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




                     },
                     style: TextButton.styleFrom(
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(32.0),
                       ),
                       backgroundColor: Colors.teal,
                       shadowColor: Colors.black,
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


Widget _buildButton(BuildContext context,
    {required String text, required IconData icon, required void Function() onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 56,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyLarge,
            ),
          ),
          const Icon(Icons.arrow_forward_ios),
        ],
      ),
    ),
  );


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
    print("Error during logout: $e");
  }
}


// Function to clear cached user data
Future<void> _clearCachedUserData() async  {

  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.clear(); // Clear all cached data
    print("Cached user data cleared");

  } catch (e) {
    print("Error clearing cached user data: $e");
  }

}
