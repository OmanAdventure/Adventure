import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/components/CustomAlertUI.dart';

import 'EditAdventureFormDetails.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booked Adventures',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MySubmittedAdventuresScreen(),
    );
  }
}

class MySubmittedAdventuresScreen extends StatefulWidget {
  const MySubmittedAdventuresScreen({super.key, });

  @override
  _MySubmittedAdventuresState createState() => _MySubmittedAdventuresState();
}

class _MySubmittedAdventuresState extends State<MySubmittedAdventuresScreen> {
  List<Adventure> adventures = [
    Adventure("Service Provider 1", "Challenging", "Only Females", "2024/05/05", 100, 5.0, 42),
    Adventure("Adventure Box Cycling", "Challenging", "Only Males", "2024/05/05", 100, 5.0, 42),
    Adventure("Service Provider 3", "Challenging", "Both", "2024/05/05", 100, 5.0, 42),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: const Text('My Booked Adventures', style: TextStyle(color: Colors.black)),
      ),
      backgroundColor: const Color(0xFFeaeaea),
      body: ListView.builder(
        itemCount: adventures.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blue[900],
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Provider name
                      Expanded(
                        // Wrap the Text widget with Expanded
                        child: Text(
                          adventures[index].provider,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          //overflow: TextOverflow.ellipsis,
                          // softWrap: false, // Ensures that the text does not wrap and uses ellipsis instead
                        ),
                      ),

                    ],
                  ),
                  const SizedBox(height: 20),
                  Text("Difficulty: ${adventures[index].difficulty}", style: const TextStyle(fontSize: 16)),
                  Text("Gender: ${adventures[index].gender}", style: const TextStyle(fontSize: 16)),
                  Text("End Date: ${adventures[index].endDate}", style: const TextStyle(fontSize: 16)),
                  Text("Price: \$${adventures[index].price} / Per Person", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                  const Divider(),
                  const SizedBox(height: 5),
                  // Location and edit button
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.blue[900],
                      ),
                      const SizedBox(width: 5), // Add some spacing between the icon and the text
                      const Expanded(
                        // Wrap the Text widget with Expanded
                        child: Text(
                          'Location of the Adventure',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16),
                          softWrap: false, // Ensures that the text does not wrap and uses ellipsis instead
                        ),
                      ),
                      IconButton(onPressed: () {

                        _showConfirmationDialog(context);


                      //  Navigator.push( context,  MaterialPageRoute(builder: (context) =>  const ManageBookingScreen(  )), );
                      },
                        icon: Icon(Icons.edit, color: Colors.red[600]),)
                    ],
                  )
                ],
              ),
            ),
          );
        },
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
              Text('Confirmation'),
            ],
          ),
          content: const Text('You would like to edit this adventure details?'),
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

                Navigator.push( context,  MaterialPageRoute(builder: (context) =>  const EditAdventureFormScreen(  )), );



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


}

class Adventure {
  String provider;
  String difficulty;
  String gender;
  String endDate;
  int price;
  double rating;
  int reviews;

  Adventure(this.provider, this.difficulty, this.gender, this.endDate, this.price, this.rating, this.reviews);
}
