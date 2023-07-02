import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(
    Accommodation()
);

class Accommodation extends StatelessWidget {
  Accommodation();

  // const Accommodation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: // MyApp(),
            hotels(),
      ),
    );
  }
}

class hotels extends StatefulWidget {
  const hotels({Key? key}) : super(key: key);
  @override
  State<hotels> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<hotels> {
  //----------------- Image Slider --------------------------------

  final List<String> images = [
    "https://cdn.pixabay.com/photo/2017/12/03/18/04/christmas-balls-2995437_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/12/13/00/23/christmas-3015776_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/19/10/55/christmas-market-4705877_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/20/00/03/road-4707345_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/22/04/18/x-mas-4711785__340.jpg",
    "https://cdn.pixabay.com/photo/2016/11/22/07/09/spruce-1848543__340.jpg"
  ];

  //------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(224, 222, 223, 1),
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
      body: Container(
        padding: const EdgeInsets.all(2.0),
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            reusableAccomWidget(
                stars: "5 Stars",
                hotel_Name:
                    "hotel_Namehotel_Namehotel_Namehotelehotel_Namehotel_Namehotel_Name",
                price: "120",
                web_Page:
                    "https://www.booking.com/hotel/tr/miss-istanbul-amp-spa.en-gb.html",
                hotel_stars_icons: const [
                  Icon(Icons.star, color: Colors.orangeAccent),
                  Icon(Icons.star, color: Colors.orangeAccent),
                  Icon(Icons.star, color: Colors.orangeAccent),
                  Icon(Icons.star, color: Colors.orangeAccent),
                  Icon(Icons.star, color: Colors.orangeAccent),
                ]),
            //----------------
            reusableAccomWidget(
                stars: "4 Stars",
                hotel_Name: "Oman Crown Plaza cc",
                price: "156",
                web_Page:
                    "https://www.booking.com/hotel/tr/ramada-plaza-istanbul-city-center.en-gb.html",
                hotel_stars_icons: const [
                  Icon(Icons.star, color: Colors.orangeAccent),
                  Icon(Icons.star, color: Colors.orangeAccent),
                  Icon(Icons.star, color: Colors.orangeAccent),
                  Icon(Icons.star, color: Colors.orangeAccent),
                  Icon(Icons.star, color: Colors.black54),
                ]),
            //----------------
          ]),
        ),
      ),
    );
  }
}

class reusableAccomWidget extends StatelessWidget {
  final List<String> images = [
    "https://cdn.pixabay.com/photo/2017/12/03/18/04/christmas-balls-2995437_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/12/13/00/23/christmas-3015776_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/19/10/55/christmas-market-4705877_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/20/00/03/road-4707345_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/22/04/18/x-mas-4711785__340.jpg",
    "https://cdn.pixabay.com/photo/2016/11/22/07/09/spruce-1848543__340.jpg"
  ];

  final List<Icon> hotel_stars_icons;
  final String stars;
  final String hotel_Name;
  final String price;
  final String web_Page;

  reusableAccomWidget(
      {required this.stars,
      required this.hotel_Name,
      required this.price,
      required this.hotel_stars_icons,
      required this.web_Page,
      images});

  @override
  Widget build(BuildContext context) {
    return GFCard(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.all(8.0),
      buttonBar: GFButtonBar(
        // padding: const EdgeInsets.fromLTRB(0, 5, 200, 1),
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.hotel, color: Colors.black),
              // Star rating of the hotel
              const Spacer(),
              // rowOfIcons(),
              Row(children: hotel_stars_icons),
              const SizedBox(width: 2),
              Text(stars),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 10.0,
                ),
                // Name of the Hotel
                Text(
                  hotel_Name,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(
                height: 10,
              ),
              Text(
                "1 night, 2 adults",
                style: TextStyle(color: Colors.blueGrey),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: null,
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0),
                    ),
                    backgroundColor: Colors.white),
                child: Text(
                  "$price OMR ",
                  //textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.blueGrey),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  var url = Uri.parse(web_Page);
                  if (await launchUrl(url)) {
                    await launchUrl(
                      url,
                      mode: LaunchMode.inAppWebView,
                    ); //forceWebView is true now
                  } else {
                    print("Could not launchCould not launchCould not launch");
                    throw 'Could not launch $url';
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.orangeAccent,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
                child: const Text("Book Now"),
              ),
            ],
          ),
        ],
      ),
      content: Container(
        // margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(1),
        child: CarouselSlider.builder(
          itemCount: images.length,
          options: CarouselOptions(
            enlargeCenterPage: true,
            height: 300,
            autoPlay: false,
            // autoPlayInterval: Duration(seconds: 3),
            reverse: false,
            aspectRatio: 5.0,
            //ScrollIndicator
          ),
          itemBuilder: (context, i, id) {
            //for onTap to redirect to another screen
            return GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.white,
                    )),
                //ClipRRect for image border radius
                child: ClipRRect(
                  // Image border
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    images[i],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              onTap: () {
                var url = images[i];
                print(url.toString());
              },
            );
          },
        ),
      ),
    );
  }
}
