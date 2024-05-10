import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:untitled/Screens/testScreen.dart';
import 'package:untitled/Screens/userProfile.dart';
import 'package:untitled/WidgetsManagement/app_styles.dart';
import 'package:untitled/main.dart';
import '../l10n/localization.dart';
import '/Screens/Adventures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup.dart';
import 'SplitScreensForm.dart';
import 'package:untitled/Screens/email_login.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mailer/mailer.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vibration/vibration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';


class adventuresfunc extends StatelessWidget {

  final String? uid;
  final int currentIndex;

  adventuresfunc({Key? key, required this.currentIndex, this.uid}) : super(key: key);

  //   const adventuresfunc({super.key, this.uid});

  @override
  Widget build(BuildContext context) {
    print("Current Index in AdventuresFunc: $currentIndex");

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: adventures(),
      ),
    );
  }
}


class adventures extends StatefulWidget {
  const adventures({Key? key}) : super(key: key);
  @override
  State<adventures> createState() => PhotoContainerScreen();
}

//-------------------
class PhotoContainerScreen extends State<adventures> {

  int _currentIndex = 0;

  late Future<UserModelProfile> _userDataFuture;
  late UserModelProfile _user;

  final String? uid;
  PhotoContainerScreen({this.uid});

  // Counting the likes
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int likeCount = 0;
  bool hasLiked = false; // Add a boolean flag to track whether the user has liked

  Future<void> _beachLikeButtonPressed() async {
    User? user = _auth.currentUser;
    if (user != null && !hasLiked) {
      // Check if the user already has a document in Firestore
      DocumentSnapshot userDoc =
      await _firestore.collection('beachLikes').doc(user.uid).get();

      if (userDoc.exists) {
        // User has an existing document, update the like count
        setState(() {
          likeCount = userDoc['likeCount'] + 1;
          hasLiked = true;
        });
        // Update the like count in Firestore
        await _firestore.collection('beachLikes').doc(user.uid).update({
          'likeCount': likeCount,
        });
        } else {
        // User does not have a document, create a new one
        setState(() {
          likeCount = 1;
          hasLiked = true;
        });
        // Create a new document in Firestore
        await _firestore.collection('beachLikes').doc(user.uid).set({
          'email': user.email,
          'userID': user.uid,
          'likeCount': likeCount,
        });
      }
    }
  }
  Future<void> _hikingLikeButtonPressed() async {
    User? user = _auth.currentUser;
    if (user != null && !hasLiked) {
      // Check if the user already has a document in Firestore
      DocumentSnapshot userDoc =
      await _firestore.collection('hikingLikes').doc(user.uid).get();

      if (userDoc.exists) {
        // User has an existing document, update the like count
        setState(() {
          likeCount = userDoc['likeCount'] + 1;
          hasLiked = true;
        });
        // Update the like count in Firestore
        await _firestore.collection('hikingLikes').doc(user.uid).update({
          'likeCount': likeCount,
        });
      } else {
        // User does not have a document, create a new one
        setState(() {
          likeCount = 1;
          hasLiked = true;
        });
        // Create a new document in Firestore
        await _firestore.collection('hikingLikes').doc(user.uid).set({
          'email': user.email,
          'userID': user.uid,
          'likeCount': likeCount,
        });
      }
    }
  }

  void _confirmBeachLike(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("New Exciting Adventure 🤩"),
          content: const Text(
            "The beach adventure is coming soon, please click the like button if you would like to bring this adventure to the app. " ,
              style: TextStyle(fontSize: 20.0),
            ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xFF700464))),
              child: Text(' Like ($likeCount) ', style: const TextStyle(color: Colors.white)),
              onPressed: () {
                _handleVibrationClick(context);
                _beachLikeButtonPressed();
                Navigator.of(context).pop(); // Close the dialog first
              },
            ),
          ],
        );
      },
    );
  }
  void _confirmHikingLike(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
           title: const Text("New Exciting Adventure 🤩"),
          content: const Text(
            "The hiking adventure is coming soon, please click the like button if you would like to bring this adventure to the app.",
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xFF700464))),
              child: Text(' Like ($likeCount) ', style: const TextStyle(color: Colors.white  )),
             // child: Text(' Like ($likeCount) ', style: const TextStyle(color: Colors.white)),
              onPressed: () {
                _handleVibrationClick(context);
                _hikingLikeButtonPressed();
                Navigator.of(context).pop(); // Close the dialog first
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleVibrationClick(BuildContext context) async {
    try {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate();
        print("Vibrating...");
      } else {
        print("Device does not have a vibrator.");
      }
    } catch (e) {
      print("Error while vibrating: $e");
    }

    // Add your other button click logic here
  }



  @override
  void initState() {
    super.initState();
    _userDataFuture = _getUserData();
    _updateIndex();
  }

  void _updateIndex([int? index]) {
    setState(() {
      _currentIndex = index ?? _currentIndex;
      print("My current index is:");
      print(_currentIndex);
    });
  }

  Future<UserModelProfile> _getUserData() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      print(user);
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
        return UserModelProfile(
          userName: userSnapshot.data()?["UserName"] ?? "",
          id: user.uid,
          email: user.email ?? "",
          phoneNumber: userSnapshot.data()?["Phone Number"] ?? "",
          gender: userSnapshot.data()?["User Gender"] ?? "",
        );
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return _user;
  }

  // Assuming you have an instance of UserModelProfile
  late UserModelProfile currentUser = _user; // Assign to _user
  late  String userName = currentUser.userName;

// for the slider indicator
  int activePage = 1;
  final List<String> images = [
    "https://cdn.pixabay.com/photo/2017/12/03/18/04/christmas-balls-2995437_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/12/13/00/23/christmas-3015776_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/19/10/55/christmas-market-4705877_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/20/00/03/road-4707345_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/22/04/18/x-mas-4711785__340.jpg",
    "https://cdn.pixabay.com/photo/2016/11/22/07/09/spruce-1848543__340.jpg"
  ];

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(images.length, (index) {
      return Container(
        margin: const EdgeInsets.all(3),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: currentIndex == index ? Color(0xFF700464) : Colors.black26,
          shape: BoxShape.circle,
        ),
      );
    });
  }
  final String title = "Oman Adventure";
  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    final appBarColor = themeProvider.darkMode
        ? themeProvider.darkTheme.primaryColor
        : Color(0xFF700464);

    return Container(
      /*
      decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/signUpScreenImage.png'),
            fit: BoxFit.cover,
          )
      ),
      */
      child:Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            //backgroundColor: Color(0xFF700464);,
             backgroundColor: appBarColor,
           // backgroundColor: Color(0xFF700464).withAlpha(100),
            title: const Text(
              'Wathbah',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                color: Colors.white,

              ),
            ),
          //  leading: IconButton(icon: const Icon(Icons.add_box_sharp), onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context ) => const AdventureFormPage()),);},),


            leading: IconButton(icon: const Icon(Icons.dark_mode,  color: Colors.white),
           onPressed: () {
             // Access the ThemeProvider and toggle the theme
             Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
             },
            ),
          ),
          body: Container(
            // padding: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(0.0),
            child: SingleChildScrollView(
              child: Column(
                //alignment:new Alignment(x, y)
                children: <Widget>[
                  // Scroll View
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          decoration:   BoxDecoration(
                                 //   color: Color(0xFF700464).withAlpha(100),
                            color: appBarColor,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(40),
                                      bottomRight: Radius.circular(40),
                                    )
                                ),
                          child:  AnimatedContainer(
                            duration: const Duration(seconds: 2),
                             curve: Curves.ease,
                              child:    Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [

                                      FutureBuilder<UserModelProfile>(
                                       future: _userDataFuture,
                                       builder: (context, snapshot) {
                                         if (snapshot.connectionState == ConnectionState.waiting) {
                                           return const Center(child: CircularProgressIndicator(color: Color(0xFF700464),));
                                         } else if (snapshot.hasError) {
                                           return const Padding(
                                             padding: EdgeInsets.all(16),
                                             child: Row(
                                               children: [
                                                 Text("Welcome ",
                                                     style: TextStyle(
                                                       fontSize: 25,
                                                       color: Colors.white,
                                                     )
                                                 ),
                                               ],
                                             ),
                                           );
                                          //  Center(child: Text("Error: ${snapshot.error}"));
                                         } else {
                                           final UserModelProfile user = snapshot.data!;
                                           return   Padding(
                                             padding: const EdgeInsets.all(16),
                                             child:  Row(
                                               children: [
                                                 const Text("Welcome " ,
                                                     style: TextStyle(
                                                       fontSize: 25,
                                                       color: Colors.white,
                                                     )
                                                 ),
                                                 Text( user.userName,
                                                     style: const TextStyle(
                                                       fontSize: 25,
                                                       color: Colors.white,
                                                     )
                                                  ),
                                               ],
                                             ),
                                           );
                                         }
                                       },
                                     ),

                               // ,,,,,,,,,,,,,,,,
                                   const SizedBox(
                                     child:  Padding(
                                       padding:   EdgeInsets.fromLTRB(20, 10, 0, 0),
                                       child: Text("  Let's Adventure together " ,
                                           style: TextStyle(
                                             fontSize: 15, color: Colors.white,
                                           )),
                                        ),
                                      ),
                                     const SizedBox(
                                       height: 50,
                                     ),

                                    ],
                                  ),
                                 ),

                        ),

                      )
                    ],
                  ),
                  // GridView

                  const SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      // horse riding
                      Expanded(
                        child: Card(
                          elevation: 18.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          clipBehavior: Clip.antiAlias,
                          margin: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                child: Image.asset(
                                "assets/images/horseback.jpg",
                                fit: BoxFit.cover,
                              ),
                                onTap: () {
                                  //  const String image = ("assets/images/horseback.jpg");
                                  const String name = ("Horse Riding");

                                //  Navigator.push(context, MaterialPageRoute(builder: (context) {return const AdventuresContainerScreen(name: name,);},),);

                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) =>const AdventuresContainerScreen(name: name,),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        const begin = Offset(1.0, 0.0);
                                        const end = Offset(0.0, 0.0);
                                        const curve = Curves.easeInOut;
                                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                        var offsetAnimation = animation.drive(tween);

                                        return SlideTransition(
                                          position: offsetAnimation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );

                                },
                              ),
                                Padding(
                                padding: EdgeInsets.fromLTRB(30.0, 8.0, 20.0, 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Horse Riding",
                                      style: Styles.headLineStyle3,
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                      // cycling
                      Expanded(
                        child: Card(
                          elevation: 18.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          clipBehavior: Clip.antiAlias,
                          margin: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                child: Image.asset(
                                  "assets/images/cycling.jpg",
                                  fit: BoxFit.cover,
                                ),
                                onTap: () {
                               //   const String image =  ("assets/images/cycling.jpg");
                                  const String name = ("Cycling");

                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) =>const AdventuresContainerScreen(name: name,),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        const begin = Offset(1.0, 0.0);
                                        const end = Offset(0.0, 0.0);
                                        const curve = Curves.easeInOut;
                                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                        var offsetAnimation = animation.drive(tween);

                                        return SlideTransition(
                                          position: offsetAnimation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                              //    Navigator.push( context,  MaterialPageRoute( builder: (context) {return const AdventuresContainerScreen(name: name,);},),);


                                },
                              ),
                              const Padding(
                                padding:
                                EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Cycling",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,

                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      // Beach Adventure
                      Expanded(
                        child: Card(
                          elevation: 18.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          clipBehavior: Clip.antiAlias,
                          margin: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                child: Image.asset(
                                  "assets/images/beach.jpg",
                                  fit: BoxFit.cover,
                                ),
                                onTap: () {

                                  // const String image = ("assets/images/beach.jpg");
                                  String name = ("Beach Adventure");
                                 _confirmBeachLike( context);


                                  /*
                                  Navigator.push(
                                    context, MaterialPageRoute( builder: (context) {return AdventuresContainerScreen(name: name,);
                                      },
                                    ),
                                  );
                                    */
                                },
                              ),

                              const Padding(
                                padding:
                                EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Beach Adventures",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,

                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // hiking
                      Expanded(
                        child: Card(
                          elevation: 18.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          clipBehavior: Clip.antiAlias,
                          margin: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                child: Image.asset(
                                  "assets/images/hiking.jpg",
                                  fit: BoxFit.cover,
                                ),
                                onTap: () {
                                  // const String image = ("assets/images/hiking.jpg");
                                  const String name = ("Hiking");
                                  _confirmHikingLike(context);
                                  /*
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const AdventuresContainerScreen(name: name,);
                                      },
                                    ),
                                  );

                                  */
                                },
                              ),
                              const Padding(
                                padding:
                                EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hiking',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,

                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 60,),

                  if (FirebaseAuth.instance.currentUser == null) // Check if user is logged in
                  Padding(
                      padding: const EdgeInsets.fromLTRB(30.0, 8.0, 20.0, 8.0),
                      child:   ElevatedButton(
                          style:  ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF700464)) ,
                              elevation: MaterialStateProperty.all<double>(10.0), // Set the elevation here
                              shadowColor: MaterialStateProperty.all<Color>(Colors.black), // Set the shadow color
                                ),
                      onPressed: ()   {

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context ) => const AdventureFormPage()),
                        );

                          }  , child: const Text('Create an Adventure', style: TextStyle(color: Colors.white),))
                  ),

 /*
                  Padding(
                      padding: const EdgeInsets.fromLTRB(30.0, 8.0, 20.0, 8.0),
                      child:   ElevatedButton(
                          style:  ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF700464)) ,
                            elevation: MaterialStateProperty.all<double>(10.0), // Set the elevation here
                            shadowColor: MaterialStateProperty.all<Color>(Colors.black), // Set the shadow color
                          ),
                          onPressed: ()   {

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context ) =>  ServiceCard()),
                            );

                          }  , child: const Text('             Test             ' , style: TextStyle(color: Colors.white)))
                  ),


                  Padding(
                      padding: const EdgeInsets.fromLTRB(30.0, 8.0, 20.0, 8.0),
                      child:   ElevatedButton(
                          style:  ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF700464)) ,
                            elevation: MaterialStateProperty.all<double>(10.0), // Set the elevation here
                            shadowColor: MaterialStateProperty.all<Color>(Colors.black), // Set the shadow color
                          ),
                          onPressed: ()   {

                            sendEmail(recipientEmail: '', mailMessage: '');

                          }  , child: const Text('             Send email             ' , style: TextStyle(color: Colors.white)))
                  ),

                  */

                ],
              ),
            ),
          ),
        //  drawer: NavigateDrawer(uid: uid)
      )  ,
    );


  }

 }


/*
class NavigateDrawer extends StatefulWidget {
  final String? uid;
  const NavigateDrawer({Key? key, this.uid}) : super(key: key);
  @override
  _NavigateDrawerState createState() => _NavigateDrawerState();
}

class _NavigateDrawerState extends State<NavigateDrawer> {
  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: Text("MY ADVENTURE Page")
    );
  }
}
*/


void sendEmail({
  required String recipientEmail,
  required String mailMessage,

}) async {
  String username = 'khalifadreamer@gmail.com'; // replace with your Gmail email
  String password = 'znlpvrtfyvwjgpqe'; // replace with your Gmail password

  final smtpServer = gmail(username, password);

  final message = Message()
    ..from = Address(username, 'Oman Adventure')
    ..recipients.add('khalifadreamer@gmail.com')
    ..subject = 'Adventure Confirmation'
    ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    ..html = '<h3>Test</h3><p>Hey! Here\'s some HTML content</p>';

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent. Error: $e');
  }
}



