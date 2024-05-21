import 'package:flutter/material.dart';
import 'package:untitled/components/buttonsUI.dart';

void main() {
  runApp(SuccessfulBookingApp());
}

class SuccessfulBookingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SuccessfulBookingScreen(),
    );
  }
}

class SuccessfulBookingScreen extends StatefulWidget {
  @override
  _SuccessfulBookingScreenState createState() => _SuccessfulBookingScreenState();
}

class _SuccessfulBookingScreenState extends State<SuccessfulBookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFeaeaea),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 500,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/horseback.jpg"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: 400), // Adjust this height to position the container correctly
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30.0),
                  padding: const EdgeInsets.all(30.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: 80, color: Colors.blue[900]),
                      SizedBox(height: 10),
                      Text(
                        'Successful Booking!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Thank you for Booking this Adventure\nPlease Check Your Email for Confirmation.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      SizedBox(height: 60),
                      CustomButton(onPressed: () {}, buttonText: "Back to Home"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
