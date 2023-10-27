import 'SettingsScreen.dart';
import 'PhotoContainerScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'VideoContainerScreen.dart';
import 'Accommodation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Notifications.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() =>  HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  final List<Widget> viewContainer = [
    const Center(
        child: adventuresfunc()),

 //   Accommodation(),
    const Notifications(),
    Settings()
  ];

  @override
  Widget build(BuildContext context) {
    void onTabTapped(int index) {
      setState(() {
        currentIndex = index;
      });
    }

    return  Scaffold(
      body: viewContainer[currentIndex],
      bottomNavigationBar:   BottomNavigationBar(
          onTap: onTabTapped, // new
          currentIndex: currentIndex,
         // fixedColor: Colors.teal,
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.teal,
          items: const [
            BottomNavigationBarItem(
              icon:    Icon(Icons.category),
              label:  "Adventures",
            ),
         //   BottomNavigationBarItem(icon:  Icon(Icons.hotel), label: "Accommodations",),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_on),
              label: "Notifications",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
            )
            // Color for the unselected items
          ]
      )
    );
    // TODO: implement build
  }
}


