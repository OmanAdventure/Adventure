import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/Screens/PhotoContainerScreen.dart';

import '../main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CongratsScreen(),
    );
  }
}

class CongratsScreen extends StatefulWidget {
  @override
  _CongratsScreenState createState() => _CongratsScreenState();
}

class _CongratsScreenState extends State<CongratsScreen> {
  late ConfettiController _controller;



  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 2));
    // Start the confetti animation
    _controller.play();
  }



  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    final appBarColor = themeProvider.darkMode
        ? themeProvider.darkTheme.primaryColor
        : Color(0xFF700464);

    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Booking Completed' ,  style: TextStyle( fontWeight: FontWeight.bold, color: Colors.white)),
        automaticallyImplyLeading: false, // Set this to false to hide the back button
        backgroundColor: appBarColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text('Congratulation!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
          const AlertDialog(
          elevation: 10,
         // title: Text('Congratulation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
          content: Text( 'We are so excited for you!\n\n'
              'Please check your email' , style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20)),
           title:   Icon(
              Icons.rocket_launch,
              color: Colors.grey,
              size: 35,
            ),
          ),
            ConfettiWidget(
              confettiController: _controller,
              blastDirection: -pi / 2, // straight up
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              maxBlastForce: 100,
              minBlastForce: 80,
              gravity: 0.1,
            ),
              const Spacer(),

            Padding(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: ElevatedButton(
                style: ButtonStyle(
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.normal)),
                    minimumSize:
                    MaterialStateProperty.all<Size>(Size(400, 50)),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.green.shade400)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => adventuresfunc(currentIndex: 0)),
                  );
                },
                child: const Text('Back to Adventures' ,  style: TextStyle( color: Colors.white) ),
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: null, // Hide the bottom navigation bar

    );

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
