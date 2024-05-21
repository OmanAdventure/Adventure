import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:untitled/Screens/SplitScreensForm.dart';
import 'package:untitled/Screens/signup.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: const Text('Service Card Example'),
        ),
        body: Center(
          child: ServiceCard(),
        ),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  final int numberOfDots;
  final int activeIndex;

  DotIndicator({required this.numberOfDots, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        numberOfDots,
            (index) => Container(
          margin: const EdgeInsets.all(5),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == activeIndex ? Colors.teal : Colors.grey,
          ),
        ),
      ),
    );
  }
}

class ServiceCard extends StatefulWidget {
  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  List<String> _images = [
    'assets/images/hiking.jpg',
    'assets/images/horseback.jpg',
    'assets/images/mountain.png',
  ];

  int _currentPage = 0;
  bool isFavorited = false;
  bool isExpanded = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Adventure Details'),
      ),
      body:   Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [

            Container(
              width: double.infinity,
              height: 300,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  PageView(
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: _images.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final String image = entry.value;

                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: Container(
                                  height: 400,
                                  width: double.infinity,
                                  color: Colors.transparent, // Background color behind the image
                                  child: PageView.builder(
                                    itemCount: _images.length,
                                    controller: PageController(initialPage: _currentPage),
                                    onPageChanged: (index) {
                                      setState(() {
                                        _currentPage = index;
                                      });
                                    },
                                    itemBuilder: (context, index) {
                                      return Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Container(
                                            height: 400,
                                            width: double.infinity,
                                            color: Colors.black, // Background color behind the image
                                            child: Image.asset(
                                              _images[index],
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          Positioned(
                                            top: 10.0,
                                            left: 10.0,
                                            child: Container(
                                              padding: const EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.7),
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              child: Text(
                                                '${index + 1} / ${_images.length}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.asset(
                                  image,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Positioned(
                                top: 5.0,
                                left: 5.0,
                                child: Container(
                                  padding: const EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    '${index + 1} / ${_images.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // Add to favorite
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: 20.0),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isFavorited = !isFavorited;
                      });
                      print("Object clicked");
                    },
                    child: Icon(
                      Icons.favorite,
                      color: isFavorited ? Colors.red : Colors.grey,
                      size: 25,
                    ),
                  ),
                ),
                const Spacer(),
                DotIndicator(
                  numberOfDots: _images.length,
                  activeIndex: _currentPage,
                ),
                const Spacer(),
                IconButton(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  icon: const Icon(Icons.ios_share, color: Colors.teal, size: 25,),
                  onPressed: () {
                    shareApp();
                  },
                ),
                const SizedBox(width: 20.0),
              ],
            ),
            const Divider(height: 1, color: Colors.grey,),

            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Hiking Tours Hiking Tours Hiking Tours Hiking Tours',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

              Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed accumsan lectus. '
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                        'Sed accumsan lectus.Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                        'Sed accumsan lectus.'

                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed accumsan lectus. '
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                        'Sed accumsan lectus.Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                        'Sed accumsan lectus.'

                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed accumsan lectus. '
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                        'Sed accumsan lectus.Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                        'Sed accumsan lectus.'

                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed accumsan lectus. '
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                        'Sed accumsan lectus.Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                        'Sed accumsan lectus. The END',
                    style: TextStyle(fontSize: 14),
                    maxLines: isExpanded ? null : 2147483647,  // Adjust the number of lines to display
                    overflow: TextOverflow.ellipsis,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Text(
                      isExpanded ? 'Read More' : 'Read Less',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                print('Book now button pressed');
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50)),
                backgroundColor: MaterialStateProperty.all(Colors.teal),
              ),
              child: const Text('Book now'),
            ),
          ],
        ),
      ),


    );

  }
}


// share the Adventure with a friend
void shareApp() async {
  const String appLink = 'https://play.google.com/store/apps/details?id=com.example.myapp';
  const String message = 'Check out this adventure: $appLink';
  await Share.share(message, subject: 'New Adventure');
}


