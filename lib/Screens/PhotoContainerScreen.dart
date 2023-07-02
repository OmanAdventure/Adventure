import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:getwidget/getwidget.dart';
import '/Screens/Adventures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import '/Screens/Accommodation.dart';
import '/Screens/HomeScreen.dart';
import 'PhotoContainerScreen.dart';
import 'Constant/Constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'signup.dart';
import 'SplitScreensForm.dart';


void main() => runApp(adventuresfunc());

class adventuresfunc extends StatelessWidget {
    final String? uid;
    adventuresfunc({this.uid});

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
  final String? uid;
  PhotoContainerScreen({this.uid});

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
              icon: Icon(Icons.add_box_sharp),
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context ) => AdventureFormPage()),
                );
              },
            ),

            actions: [IconButton(

              onPressed: () {
                FirebaseAuth auth = FirebaseAuth.instance;
                auth.signOut().then((res) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                          (Route<dynamic> route) => false);
                });
              },
              icon: Icon(Icons.exit_to_app),
            ),],
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
                              child:  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                   children:     [
                            Padding(
                               padding:   EdgeInsets.fromLTRB(20, 40, 0, 0),
                                  child:  Row(
                                      children: const [
                                           Text("Welcome Back vladimir  " ,
                                               style: TextStyle(
                                                fontSize: 25,
                                                    )
                                                   ),
                                                 ],
                                            ),
                                        ),

                                   const SizedBox(
                                     child:  Padding(
                                       padding:   EdgeInsets.fromLTRB(20, 20, 0, 0),
                                       child: Text('Lets Adventure together ' ,
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
                                  const String image = ("assets/images/hiking.jpg");
                                  const String name = ("Hiking");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RouteTwo(image: image, name: name)),
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
                                  const String image =
                                  ("assets/images/cycling.jpg");
                                  const String name = ("Cycling");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RouteTwo(image: image, name: name)),
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
                                  const String image = ("assets/images/beach.jpg");
                                  String name = ("Beach");

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return AdventuresContainerScreen();
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
                                  const String image =
                                  ("assets/images/horseback.jpg");
                                  const String name = ("Horse Riding");

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return AdventuresContainerScreen();
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
                ],
              ),
            ),
          ),
          drawer: NavigateDrawer(uid: this.uid)
      )  ,
    );


  }
}


class RouteTwo extends StatelessWidget {
  final String image;
  final String name;

  RouteTwo({Key? key, required this.image, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      backgroundColor: const Color(0xFFeaeaea),
      body: Container(
        padding: const EdgeInsets.all(4.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 1.0,
                margin: const EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Image.asset(
                          image,
                          width: 100.0,
                          height: 100.0,
                        ),
                        const SizedBox(width: 40.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const <Widget>[
                            Text(
                              ("The name of the service"),
                              textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.normal),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              ("The name of the service provider"),
                              textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.attach_money,
                              color: Colors.teal,
                              size: 30,
                            ),
                            const SizedBox(
                              width: 70.0,
                            ),
                            IconButton(
                              iconSize: 30,
                              icon: const Icon(Icons.location_on_outlined),
                              color: Colors.teal,
                              onPressed: () {},
                            ),
                            const SizedBox(
                              width: 70.0,
                            ),
                            ElevatedButton(
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32.0),
                                    ),
                                    backgroundColor: Colors.red),
                                onPressed: () {
                                  print("Button Pressed ");
                                },
                                child: const Text("Let's do it"))
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//}

class NavigateDrawer extends StatefulWidget {
  final String? uid;
  NavigateDrawer({Key? key, this.uid}) : super(key: key);
  @override
  _NavigateDrawerState createState() => _NavigateDrawerState();
}

class _NavigateDrawerState extends State<NavigateDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Text("MY ADVENTURE PAGE")
    );
  }
}



