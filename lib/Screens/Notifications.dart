import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Screens/PhotoContainerScreen.dart';
import 'SettingsScreen.dart';

void main() => runApp(
    Notifications()
);

class Notifications extends StatelessWidget {
  Notifications();

  // const Accommodation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: // MyApp(),
        notificationState(),
      ),
    );
  }
}

class notificationState extends StatefulWidget {
  const notificationState({Key? key}) : super(key: key);
  @override
  State<notificationState> createState() => _MyNotificationState();
}

class _MyNotificationState extends  State<notificationState> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFeaeaea),
      appBar: AppBar(
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
        centerTitle: false,
        backgroundColor: Colors.teal,
        elevation: 0.0,

        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Settings()),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],


      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child:  SizedBox(
          height: 500,
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const <Widget>[
                    Icon(Icons.cloud_sharp, color: Colors.teal, size: 90,),
                    SizedBox(width: 8.0),
                    Text('No adventures have been booked yet.')
                  ])
          ),
        )
      ),
    );
  }


}
