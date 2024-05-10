import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:untitled/Screens/form_completed.dart';
import 'package:untitled/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

// Define a custom Form widget.
class FavoriteAdventuresDetails extends StatefulWidget {

   final DateTime? AdventureAddedDate ;
   final String adventureID;
  final String  adventureProviderName ;
  final String typeOfAdventure ;
  final String adventureDescription;
  final String phoneNumber;
  final String difficultyLevel ;

  final String startDate ;
  final String endDate;
  final String startTime;
  final String endTime;

  final String onlyFamilies;
  final String adventureNature;
  final String age;
  final String gender;

  final String freeAdventure;
  final String price;
  final String  maxNumberOfParticipants;
  final String googleMapsLink;
  final String locationName;
  final List  images;

  const FavoriteAdventuresDetails({Key? key,

    required this.AdventureAddedDate,
    required this.adventureID,

    required this.adventureProviderName,
    required this.adventureDescription,
    required this.phoneNumber,
    required this.difficultyLevel,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.onlyFamilies,
    required this.adventureNature,
    required this.age,
    required this.gender,
    required this.freeAdventure,
    required this.price,
    required this.maxNumberOfParticipants,
    required this.googleMapsLink,
    required this.locationName,
    required this.typeOfAdventure,
    required this.images,


  }) : super(key: key);

  @override
  FavoriteAdventuresDetailsState createState() => FavoriteAdventuresDetailsState(


     AdventureAddedDate : AdventureAddedDate,
    adventureID : adventureID,


    adventureProviderName  : adventureProviderName,
    typeOfAdventure  :typeOfAdventure,
    adventureDescription:adventureDescription,
    phoneNumber:phoneNumber,
    difficultyLevel :difficultyLevel,

    startDate :startDate,
    endDate:endDate,
    startTime:startTime,
    endTime: endTime,

    onlyFamilies:onlyFamilies,
    adventureNature:adventureNature,
    age:age,
    gender:gender,

    freeAdventure:freeAdventure,
    price:price,
    maxNumberOfParticipants:maxNumberOfParticipants,
    googleMapsLink:googleMapsLink,
    locationName:locationName,

    images : images,

  );
}


class CounterDisplay extends StatelessWidget {
  const CounterDisplay({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Text( '$count  ' , style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20), );
  }
}

class DotIndicator extends StatelessWidget {
  final int numberOfDots;
  final int activeIndex;


  DotIndicator({required this.numberOfDots, required this.activeIndex,  });

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
            color: index == activeIndex ? const Color(0xFF700464) : Colors.grey,
          ),
        ),
      ),
    );
  }
}


class FavoriteAdventuresDetailsState extends State<FavoriteAdventuresDetails> {

  bool _isSubmitting = false;
  int _currentPage = 0;
  int numOfReservedAdven = 1;
  bool isFavorited = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  void _increment() {
    setState(() {
      int intMaxNumberOfParticipants = int.parse(maxNumberOfParticipants);
      if (numOfReservedAdven < intMaxNumberOfParticipants) {
        ++numOfReservedAdven;
        _calculatTotalPrice();
      } else {
        // Show an alert that you have reached the max number of participants
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Opps'),
              content:  const Text('You have reached the maximum number of participants for this adventure.'),
              actions: <Widget>[
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF700464)),
                  ),
                  child: const Text('Ok', style: TextStyle(color: Colors.white,)),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }
  void _decrement() {
    setState(() {
      if (numOfReservedAdven > 1) {
        --numOfReservedAdven;
        _calculatTotalPrice();
      }
    });
  }

  TextSpan _boldTextSpan(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
    );
  }

  int _calculatTotalPrice() {

    String currency = price.substring(0, 3);  // Extract the first three characters ("OMR")
    String amount = price.substring(4);       // Extract the characters starting from the fourth position ("15")

    print("Currency: $currency");
    print("Amount: $amount");
    print("Number of Reserved Adventure: $numOfReservedAdven");

    int  intPrice = int.parse(amount);
    int TotalPrice = numOfReservedAdven * intPrice ;
    print("TotalPrice: $TotalPrice " );

    return TotalPrice; // Return the calculated TotalPrice
  }

  void _confirmBooking(BuildContext context) {

    int TotalPrice = _calculatTotalPrice(); // Call _calculatTotalPrice to get the calculated TotalPrice

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Reservation'),
          content: RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                    text: ' \nNumber of reserved adventures: ',  style: TextStyle(color: Colors.black)
                ),
                _boldTextSpan(numOfReservedAdven.toString()),
                const TextSpan(
                    text: ' \n \nTotal Price: ',  style: TextStyle(color: Colors.black)
                ),
                _boldTextSpan('$TotalPrice OMR'),
              ],
            ),
          ),

          actions: <Widget>[
            TextButton(
              child: const Text('Yes, Confirm', style: TextStyle(color: Color(0xFF700464))),
              onPressed: () {
                _confirmAdventure();
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF700464))),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog

              },
            ),
          ],
        );
      },
    );
  }

  //  Screen Content is displayed from here
  final  DateTime? AdventureAddedDate  ;
  final String adventureID;

  final String adventureProviderName ;
  final String typeOfAdventure  ;
  final String adventureDescription;
  final String phoneNumber ;
  final String difficultyLevel;
  final String startDate ;
  final String endDate ;
  final String startTime;
  final String endTime ;
  final String onlyFamilies ;
  final String adventureNature;
  final  String age ;
  final String gender ;
  final String freeAdventure ;
  final String price ;
  final  String maxNumberOfParticipants;
  final String googleMapsLink;
  final String locationName ;
  final List? images;

  //  final String NumOfReservedAdven;

  FavoriteAdventuresDetailsState({
    required this.AdventureAddedDate,
    required this.adventureID,

    required this.adventureProviderName,
    required this.typeOfAdventure,
    required this.adventureDescription,
    required this.phoneNumber,
    required this.difficultyLevel,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.onlyFamilies,
    required this.adventureNature,
    required this.age,
    required this.gender,
    required this.freeAdventure,
    required this.price,
    required this.maxNumberOfParticipants,
    required this.googleMapsLink,
    required this.locationName,
    required this.images,
  });


  @override
  Widget build(BuildContext context) {
    // Parse the string into a DateTime object using a custom format
    List<String> dateParts = endDate.split('/');
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);
    DateTime formattedendDate = DateTime(year, month, day);
    if (kDebugMode) {
      print('Original Date String: $formattedendDate');
    }
    DateTime currentDate = DateTime.now();

    // Compare the two DateTime objects
    if (formattedendDate.isBefore(currentDate)) {
      if (kDebugMode) {
        print('The converted date is before the current date.');
      }
    } else if (formattedendDate.isAfter(currentDate)) {
      if (kDebugMode) {
        print('The converted date is after the current date.');
      }
    } else {
      if (kDebugMode) {
        print('The converted date is the same as the current date.');
      }
    }

    final themeProvider = Provider.of<ThemeProvider>(context);
    final appBarColor = themeProvider.darkMode
        ? themeProvider.darkTheme.primaryColor
        : const Color(0xFF700464);

    User? currentUser = FirebaseAuth.instance.currentUser;
    if (kDebugMode) {
      print('User ID: ${currentUser?.uid}');
    }

//   add to favorites
    Future addToFavorite() async {

      // Call _calculatTotalPrice to get the calculated TotalPrice
      int TotalPrice = _calculatTotalPrice();
      print('Current Total Price -->-------------------***');
      print(TotalPrice);

      final favoriteAdventure = {
        "AdventureAddedDate" :  DateTime.now(),
        'adventureID': adventureID, // add the UUID to the map
        'userID': currentUser?.uid,
        // 'Number of Reserved Adventures': numOfReservedAdven,
        // 'Paid' : paid,
        'serviceProviderName': adventureProviderName,
        'typeOfAdventure': typeOfAdventure,
        'adventureDescription': adventureDescription,
        'PhoneNumber':phoneNumber,
        'levelOfDifficulty' : difficultyLevel ,
        'startDate' : startDate,
        'endDate': endDate,
        'startTime':  startTime,
        'endTime': endTime,
        'isOnlyFamily' : onlyFamilies,
        'adventureNature' :  adventureNature,
        'Gender' : gender ,
        'Age' : age ,
        "IsFreeAdventure" : freeAdventure,
        'Price' : TotalPrice.toString(),
        'MaxNumberOfParticipants' : maxNumberOfParticipants,
        'googleMapsLink ': googleMapsLink ,
        'LocationName': locationName ,
        'imageUrls' : images
      };

      FirebaseFirestore.instance.collection("user-favorite-items").
      doc(currentUser?.uid).
      collection("favorite-items").
      add(favoriteAdventure);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(  behavior: SnackBarBehavior.floating,
              content: Text('Added to Favorite', style: TextStyle(color: Color(
                  0xFFFFFFFF)),)));
    }

//   Remove from favorites
    Future removeFromFavorite() async {
      // Display confirmation dialog
      bool removeConfirmed = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Remove from Favorites'),
            content: const Text(
                'Are you sure you want to remove this adventure from your favorites?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Dismiss the dialog with false
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Dismiss the dialog with true
                },
                child: const Text('Remove'),
              ),
            ],
          );
        },
      );

      // Check if the user confirmed the removal
      if (removeConfirmed == true) {
        try {
          // Assuming adventureID is used to uniquely identify the favorite adventure
          String adventureIDToRemove = adventureID;

          // Query to find the specific document to remove
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection("user-favorite-items")
              .doc(currentUser?.uid)
              .collection("favorite-items")
              .where('adventureID', isEqualTo: adventureIDToRemove)
              .get();

          // Check if any matching documents were found
          if (querySnapshot.docs.isNotEmpty) {
            // Delete the document
            querySnapshot.docs.first.reference.delete();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(
                  'Removed from Favorite',
                  style: TextStyle(color: Color(0xFFFFFFFF)),
                ),
              ),
            );
          } else {
            // Document not found, you may want to handle this case
            print('Document not found in favorites');
          }
        } catch (e) {
          print('Error removing from favorites: $e');
          // Handle the error, e.g., show an error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(
                'Error removing from Favorite',
                style: TextStyle(color: Color(0xFFFFFFFF)),
              ),
            ),
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarColor,
        title: const Text(
          'Adventure Confirmation',
          style: TextStyle(
            // fontSize: 20,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
            color: Colors.white,
          ),

        ),
      ),
      body: SingleChildScrollView(
        key: _scaffoldKey,
        child: Column(
          children: <Widget>[
            // Images container
            Container(
              margin: const EdgeInsets.fromLTRB(10, 2, 10, 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                  children: <Widget>[
                    // adventure Provider Name
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child:  Container(
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
                              children: images!.asMap().entries.map((entry) {
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
                                              itemCount: images!.length,
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
                                                        images![index],
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
                                                          '${index + 1} / ${images!.length}',
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
                                              '${index + 1} / ${images!.length}',
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
                    ),
                  ]
              ),
            ),
            // Add to favorite
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: 20.0),
                // Add to favorite
                StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("user-favorite-items").doc(FirebaseAuth.instance.currentUser !. uid)
                        .collection("favorite-items").where("adventureID", isEqualTo: widget.adventureID).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return const Text("");
                      }
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: IconButton(
                            onPressed: () {
                              if (snapshot.data.docs.length == 0) {
                                // Item is not in favorites, add it
                                addToFavorite();
                              } else {
                                // Item is already in favorites, remove it
                                removeFromFavorite();
                              }
                            },
                            icon: snapshot.data.docs.length == 0 ?
                            const Icon(
                              Icons.favorite_outline,
                              color: Colors.red,
                              size: 25,
                            ) : const Icon( // Icon
                              Icons.favorite,
                              color: Colors.red,
                              size: 25,
                            ), // Icon
                          ), // IconButton
                        ), // CircleAvatar
                      ); // Padding
                    }
                ),
                const Spacer(),
                DotIndicator(
                  numberOfDots:  images!.length,
                  activeIndex: _currentPage,
                ),
                const Spacer(),
                IconButton(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  icon: const Icon(Icons.ios_share, color: Color(0xFF700464), size: 25,),
                  onPressed: () {
                    shareApp();
                  },
                ),
                const SizedBox(width: 20.0),
              ],
            ),
            const Divider(height: 0.5, color: Colors.grey,),

            // First Container
            Container(
              margin: const EdgeInsets.fromLTRB(10, 2, 10, 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                  children: <Widget>[
                    // adventure Provider Name
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: ListTile(
                        leading: const Icon(Icons.local_activity),
                        title: Text(
                          adventureProviderName,
                        ),
                      ),
                    ),
                    // Type Of Adventure
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: ListTile(
                        leading: const Icon(Icons.category),
                        title: Text(
                            typeOfAdventure
                        ),
                      ),
                    ),
                    // Adventure Description
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: ListTile(
                        leading: const Icon(Icons.description),
                        title: Text(
                            adventureDescription
                        ),
                      ),
                    ),
                    //difficulty Level
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                      child: ListTile(
                        leading: const Icon(Icons.local_activity),
                        title: Text(
                            difficultyLevel
                        ),
                      ),
                    ),
                  ]
              ),
            ),

            // Start Data and Time
            Container(
              margin: const EdgeInsets.fromLTRB(10, 2, 10, 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.date_range),
                      title: Text(
                        'Starts on:  $startDate ',
                      ),
                      trailing: Text(
                        startTime,  style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ]
              ),
            ),
            //  End Data and Time
            Container(
              margin: const EdgeInsets.fromLTRB(10, 2, 10, 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.date_range),
                      title: Text(
                        'End on:     $endDate',
                      ),
                      trailing: Text(
                        endTime,  style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ]
              ),
            ),
            // Price and Free Adventure
            Container(
              margin: const EdgeInsets.fromLTRB(10, 2, 10, 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: _isSubmitting
                  ? const Center(
                child: CircularProgressIndicator(color: Colors.red),
              )
                  : Column(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.monetization_on),
                    title: Text(price),
                    trailing: Text(freeAdventure),
                  ),
                ],
              ),
            ),
            // Adventure Nature and if Family
            Container(
              margin: const EdgeInsets.fromLTRB(10, 2, 10, 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.group),
                      title: Text(
                        adventureNature,
                      ),
                      trailing: Text(
                        onlyFamilies,  style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ]
              ),
            ),
            // Age and Gender
            Container(
              margin: const EdgeInsets.fromLTRB(10, 2, 10, 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.man),
                      title: Text(
                        'Age Group: $age',
                      ),
                      trailing: Text(
                        'Gender: $gender', style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ]
              ),
            ),
            //  Number of Participants
            Container(
              margin: const EdgeInsets.fromLTRB(10, 2, 10, 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),

              child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.groups),
                      title:   Text(
                          "Number of Participants:  $maxNumberOfParticipants"
                      ),
                      //   trailing: Text(  maxNumberOfParticipants),
                    ),
                  ]
              ),

            ),
            // Location
            Container(
              margin: const EdgeInsets.fromLTRB(10, 2, 10, 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.location_on_sharp),
                      title: Text(
                        'Location: $locationName',
                      ),
                      trailing:     ElevatedButton(

                        onPressed: () {
                          final snackBar = SnackBar(
                            content: const Text('Do you want to open the location in Google Maps?'),
                            action: SnackBarAction(
                              label: 'Open',
                              onPressed: () async {
                                final url = Uri.parse( googleMapsLink );
                                print(url);
                                if (await canLaunch(url.toString())) {
                                  await launch(url.toString());
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        child: const Icon(Icons.location_on_outlined, size: 30, color: Color(0xFF700464)),
                        style: TextButton.styleFrom(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9.0),
                          ),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ]
              ),
            ),
            // Number of reserved Tickets
            Container(
              margin: const EdgeInsets.fromLTRB(10, 2, 10, 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child:   Row(
                  children: <Widget>[
                    const SizedBox(width: 17,),
                    const Column(
                        children: <Widget>[
                          Icon(Icons.local_activity),
                        ]
                    ),
                    const SizedBox(width: 12,),
                    const Column(
                        children: <Widget>[
                          Text("Number of Reserved \n Adventures:"),
                        ]
                    ),
                    const Spacer(),
                    Column(
                        children: <Widget>[
                          TextButton.icon(onPressed: _increment, icon:  const Icon(Icons.add, color: Color(0xFF700464), size: 30,), label: const Text(''),),
                        ]
                    ),

                    Column(
                        children: <Widget>[
                          CounterDisplay(count: numOfReservedAdven),
                        ]
                    ),

                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(''),
                          TextButton.icon(onPressed: _decrement, icon:  const Icon(Icons.maximize, color: Color(0xFF700464), size: 30, ), label: const Text(''),),
                        ]
                    ),
                  ]
              ),
            ),

            // Submit button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Stack(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(const Size(double.infinity, 50)),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green.shade500),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      int convertedMaxNumberOfParticipants = int.tryParse(maxNumberOfParticipants) ?? 0;
                      if (convertedMaxNumberOfParticipants != 0) {
                        //   _confirmBooking(context);
                        //Push the user to the payment screen
                        Navigator.push( context, MaterialPageRoute(builder: (context) =>   CongratsScreen()),);

                      } else {
                        maxNumberOfParticipants == 0 ? null :  _confirmBooking(context);

                      }
                    },
                    child: const Text('Confirm', style: TextStyle( color: Colors.white, fontSize: 20),),
                  ),
                  // While submitting
                  if (_isSubmitting == true)
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(

                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(30)
                      ),// Change to the desired color for the disabled button
                      child: const Center (
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                          child: Text(
                            'Please Wait...',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15 ), // Customize text style
                          ),
                        ),
                      ),
                    ),
                  // This adventure is fully booked
                  if (int.tryParse(maxNumberOfParticipants) == 0)
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(

                          color: Colors.red.shade600,
                          borderRadius: BorderRadius.circular(30)
                      ),// Change to the desired color for the disabled button
                      child: const Center (
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                          child: Text(
                            'This adventure is fully booked',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15 ), // Customize text style
                          ),
                        ),
                      ),
                    ),

                  // This adventure is expired
                  if (formattedendDate.isBefore(currentDate))
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.red.shade600,
                          borderRadius: BorderRadius.circular(30)
                      ),
                      // Change to the desired color for the disabled button
                      child: const Center (
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                          child: Text(
                            'This adventure is expired',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15  ), // Customize text style
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

// ---------------------- To Firebase ----------------------
  Future<void> _confirmAdventure() async {

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // No internet connection
      _showNoInternetDialog();
      return;
    }

    setState(() {
      _isSubmitting = true;

    });

    try {

      // Generate a UUID
      final uuid = const Uuid().v4();
      final AdventureID = adventureID;
      print("object:  $uuid" );
      User? user = FirebaseAuth.instance.currentUser;
      String userID = "";
      userID = user!.uid;
      print('Current User ID -->: $userID');

      // Call _calculatTotalPrice to get the calculated TotalPrice
      int TotalPrice = _calculatTotalPrice();
      print('Current Total Price -->-------------------***');
      print(TotalPrice);


      // Increment the adventure count
      final doc = await FirebaseFirestore.instance.collection('booked_adventure_count').doc('count').get();
      final count = doc.exists ? doc.data()!['count'] as int : 0;
      await FirebaseFirestore.instance.collection('booked_adventure_count').doc('count').set({'count': count + 1});

// -----------------Try updating the Max number of participants ----------------
      print('my adventure ID is');
      print(AdventureID);
      // Update the document with the specified adventureID
      final getAdv = await FirebaseFirestore.instance.collection('adventure')
          .where("adventureID", isEqualTo: AdventureID)
          .where("MaxNumberOfParticipants", isEqualTo: maxNumberOfParticipants)
          .get();


      if (getAdv.docs.isNotEmpty) {
        // Assuming you want to update only the first matching document.
        final documentSnapshot = getAdv.docs.first;
        final data = documentSnapshot.data();

        int currentMaxParticipants = int.tryParse(data['MaxNumberOfParticipants'] ?? '0') ?? 0;
        print('my MaxNumberOfParticipants is');
        print(currentMaxParticipants);

        if (currentMaxParticipants > 0) {
          // after booking decrement one
          currentMaxParticipants--;
          // Update the MaxNumberOfParticipants
          await documentSnapshot.reference.update({'MaxNumberOfParticipants': currentMaxParticipants.toString()});

          print('Partic After Decremented is');
          print(currentMaxParticipants);

        } else {
          print('MaxNumberOfParticipants is already at its minimum.');
        }
      } else {
        print('No adventure found with the given adventureID and MaxNumberOfParticipants.');
      }

// ---------------------------------------------------------
      bool paid = false;

      // Add the adventure data to Firestore with the UUID and count
      final bookedAdventureData = {

        'adventureBookingDate': DateTime.now(),
        'bookingStatus' : 'Booked',
        'adventureBookingID': uuid, // add the UUID to the map
        'bookedAdventureNumber': count + 1,
        'userID': userID,
        'Number of Reserved Adventures': numOfReservedAdven,
        'Paid' : paid,

        'serviceProviderName': adventureProviderName,
        'typeOfAdventure': typeOfAdventure ,
        'adventureDescription': adventureDescription,
        'PhoneNumber':phoneNumber,
        'levelOfDifficulty' : difficultyLevel ,

        'startDate' : startDate,
        'endDate': endDate,
        'startTime':  startTime,
        'endTime': endTime,

        'isOnlyFamily' : onlyFamilies,
        'adventureNature' :  adventureNature,
        'Gender' : gender ,
        'Age' : age ,

        "IsFreeAdventure" : freeAdventure,
        'Price' : TotalPrice.toString(),
        'MaxNumberOfParticipants' : maxNumberOfParticipants,

        'googleMapsLink ': googleMapsLink ,
        'LocationName': locationName ,

      };
      await FirebaseFirestore.instance
          .collection('BookedAdventure')
          .add(bookedAdventureData);
      // ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Your Adventure Booked Successfully')));

      //Push the user to the payment screen
      Navigator.push( context, MaterialPageRoute(builder: (context) =>   CongratsScreen()),);

      setState(() {
        _isSubmitting = false;
      });
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
      setState(() {
        _isSubmitting = false;
      });
    }
  }
///---------------------  No Internet Dialog ----------------------------
  void _showNoInternetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text('Please connect to a stable internet connection and try again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
/// ---------------------- End No Internet Dialog -------------------------

}



// share the Adventure with a friend
void shareApp() async {
  const String appLink = 'https://play.google.com/store/apps/details?id=com.example.myapp';
  const String message = 'Check out this adventure: $appLink';
  await Share.share(message, subject: 'New Adventure');
}