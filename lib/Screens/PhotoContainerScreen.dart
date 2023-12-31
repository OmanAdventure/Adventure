import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Screens/userProfile.dart';
import 'package:untitled/main.dart';
import '/Screens/Adventures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup.dart';
import 'SplitScreensForm.dart';


class adventuresfunc extends StatelessWidget {

  final String? uid;
    const adventuresfunc({super.key, this.uid});

  @override
  Widget build(BuildContext context) {


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


  late Future<UserModelProfile> _userDataFuture;
  late UserModelProfile _user;



  final String? uid;
  PhotoContainerScreen({this.uid});


  @override
  void initState() {
    super.initState();


    _userDataFuture = _getUserData();

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
          color: currentIndex == index ? Colors.teal : Colors.black26,
          shape: BoxShape.circle,
        ),
      );
    });
  }
  final String title = "Oman Adventure";
  @override
  Widget build(BuildContext context) {
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
            backgroundColor: Colors.teal,
            title: Text(
              'Oman Adventure',
              style: GoogleFonts.satisfy(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                color: Colors.white,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.add_box_sharp),
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context ) => const AdventureFormPage()),
                );
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
                                    color: Colors.teal.shade50,
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
                                           return const Center(child: CircularProgressIndicator());
                                         } else if (snapshot.hasError) {
                                           return const Padding(
                                             padding: EdgeInsets.all(16),
                                             child: Row(
                                               children: [
                                                 Text("Welcome back ",
                                                     style: TextStyle(
                                                       fontSize: 25,
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
                                                 const Text("Welcome back " ,
                                                     style: TextStyle(
                                                       fontSize: 25,
                                                     )
                                                 ),
                                                 Text( user.userName,
                                                     style: const TextStyle(
                                                       fontSize: 25,
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
                                       padding:   EdgeInsets.fromLTRB(20, 20, 0, 0),
                                       child: Text("Let's Adventure together " ,
                                           style: TextStyle(
                                             fontSize: 15, color: Colors.grey,
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

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const AdventuresContainerScreen(name: name,);
                                      },
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hiking',
                                      style: GoogleFonts.satisfy(
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
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const AdventuresContainerScreen(name: name,);
                                      },
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Cycling",
                                      style: GoogleFonts.satisfy(
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
                  // Grid view
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
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

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return AdventuresContainerScreen(name: name,);
                                      },
                                    ),
                                  );
                                  /*
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RouteTwo(image: image, name: name)),
                              );
                              */
                                },
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Beach Adventures",
                                      style: GoogleFonts.satisfy(
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

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const AdventuresContainerScreen(name: name,);
                                      },
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(30.0, 8.0, 20.0, 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Horse Riding",
                                      style: GoogleFonts.satisfy(
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

                  const SizedBox(height: 30,),

                  /*
                  Padding(
                      padding: const EdgeInsets.fromLTRB(30.0, 8.0, 20.0, 8.0),
                      child:   TextButton(
                          onPressed: () async {
                            // To get User Token
                            await FirebaseMessaging.instance.getToken().then((token)  {
                              print(" User Token is:   $token");
                            //  initPushNotifications();
                            });
                          }  , child: Text('Token is'))
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
      child: Text("MY ADVENTURE PAGE")
    );
  }
}
*/


