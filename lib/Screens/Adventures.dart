import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:untitled/Screens/SplitScreensForm.dart';
import 'package:untitled/Screens/signup.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../main.dart';
import 'HomeScreen.dart';
import 'email_login.dart';
import 'email_signup.dart';
import 'CustomerAdventureForm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AdventuresContainerScreen extends StatefulWidget {

  final String name;
  const AdventuresContainerScreen({super.key,  required this.name});

  @override
  _AdventuresContainerScreenState createState() => _AdventuresContainerScreenState(name: name);
}

class _AdventuresContainerScreenState extends State<AdventuresContainerScreen> {
  late Stream<QuerySnapshot> _adventuresStream;
  late List<Map<String, dynamic>> _cachedAdventures = [];
  late SharedPreferences _prefs;
  final String name;
  String _priceSortOrder = 'LowToHigh'; // Default sorting order for price
  String _difficultyFilter = 'All'; // Default difficulty filter
  String  _stringPrice = "";
  String _genderFilter = 'All';

  _AdventuresContainerScreenState({required this.name});

  @override
  void initState() {
    super.initState();
    var adventureType = name;

    _adventuresStream = FirebaseFirestore.instance.collection('adventure')
        .where("typeOfAdventure", isEqualTo: adventureType )
      //  .orderBy('adventureCreationDate', descending: true)
        .snapshots();

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _prefs = prefs;
        _initPrefs(); // Call _initPrefs() after setting _prefs variable
        final String? adventuresJson = prefs.getString('adventures');
        if (adventuresJson != null) {
          final List<dynamic> adventuresData = jsonDecode(adventuresJson);
          _cachedAdventures = adventuresData
              .map((adventureData) => Map<String, dynamic>.from(adventureData))
              .toList();
        }
      });
    });


  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void updateState() {
    setState(() {
      print("123456789");
    });
  } // Use setState here


  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    final appBarColor = themeProvider.darkMode
        ? themeProvider.darkTheme.primaryColor
        : Color(0xFF700464);;

    return Scaffold (
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(name, style: TextStyle(    color: Colors.white,)),
        centerTitle: true,
        backgroundColor: appBarColor,
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterOptions(context);
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(2.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: _adventuresStream,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {

                    print('Error in StreamBuilder: ${snapshot.error}');
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 500,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.data == null || snapshot.data!.size == 0) {
                    return const SizedBox(
                      height: 500,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.cloud_sharp, color: Color(0xFF700464), size: 90),
                            SizedBox(width: 8.0),
                            Text('No adventures have been posted yet.'),
                          ],
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {

                      final Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                      // Convert Timestamp to DateTime
                      print("Data received: $data"); // Add this line

                      // Create a new variable named priceString
                      String  _stringPrice = data['price'];
                      print(_stringPrice);
                      print('priceString');


                      // Convert Timestamp to DateTime
                      final Timestamp creationTimestamp = data['adventureCreationDate'] as Timestamp;
                      final DateTime creationDate = creationTimestamp.toDate();

                      return ReusableCard(
                        adventureCreationDate: creationDate,
                        adventureID : data['adventureID'],
                        gender: data['gender'] ?? '',
                        age: data['age'] ?? '',
                        startDate: data['startDate'] ?? '',
                        endDate: data['endDate'] ?? '',
                        startTime: data['startTime'] ?? '',
                        endTime: data['endTime'] ?? '',
                        uuid: data['uuid'] ?? '',
                        adventureProviderName: data['serviceProviderName'] ?? '',
                        count: data['count'] ?? '',
                        typeOfAdventure: data['typeOfAdventure'] ?? '',
                        phoneNumber: data['phoneNumber'] ?? '',
                        equipmentProvided: data['isEquipmentProvided'] ?? '',
                        difficultyLevel: data['levelOfDifficulty'] ?? '',
                        price: data['price'] ?? '',
                        adventureNature: data['adventureNature'] ?? '',
                        freeAdventure: data['isFreeAdventure'] ?? '',
                        onlyFamilies: data['isOnlyFamily'] ?? '',
                        maxNumberOfParticipants: data['maxNumberOfParticipants'] ?? '',
                        googleMapsLink: data['googleMapsLink'] ?? '',
                        adventureDescription: data['adventureDescription'] ?? '',
                        locationName: data['locationName'] ?? '',
                      );
                    }).toList(),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _convertDocumentToJson(DocumentSnapshot document) {
    final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    // Convert Timestamp to milliseconds since Unix epoch
    final Timestamp creationTimestamp = data['adventureCreationDate'] as Timestamp;
    final int milliseconds = creationTimestamp.millisecondsSinceEpoch;
    data['adventureCreationDate'] = milliseconds;
    print('data[adventureCreationDate].runtimeType');
    print(data['adventureCreationDate'].runtimeType);
    return data;
  }
  // ------------- convert to Json

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Filter Options'),
              ListTile(
                title: const Text('Select gender group:'),
                trailing: DropdownButton<String>(
                  value: _genderFilter,
                  onChanged: (String? newValue1) {
                    print('Selected value: $newValue1');
                    setState(() {
                      _genderFilter = newValue1 ?? 'All';
                    });
                  },
                  items: ['All', 'Only Females', 'Only Males', 'Both genders']
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          color: value ==  _genderFilter ? Color(0xFF700464) : null,
                        ),
                      ),
                    ),
                  )
                      .toList(),
                ),
              ),

              ListTile(
                title: const Text('Select difficulty level:'),
                trailing: DropdownButton<String>(
                  value: _difficultyFilter,
                  onChanged: (String? newValue) {
                    print('Selected value: $newValue');
                    setState(() {
                      _difficultyFilter = newValue ?? 'All';
                    });
                  },
                  items: ['All', 'Easy', 'Moderate', 'Challenging']
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          color: value == _difficultyFilter ? Color(0xFF700464) : null,
                        ),
                      ),
                    ),
                  )
                      .toList(),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xFF700464))),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the bottom sheet
                  // Trigger a new query based on the selected filters
                  _updateAdventuresStream();
                },
                child: const Text('Apply Filters'),
              ),

              // Add Reset Filter Button
              ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the bottom sheet
                  // Reset filters
                  setState(() {
                    _genderFilter = 'All';
                    _difficultyFilter = 'All';
                  });
                  // Trigger a new query based on the selected filters
                  _updateAdventuresStream();
                },
                child: const Text('Reset Filters'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateAdventuresStream( ) {
    // Update the _adventuresStream based on the selected filters
    var adventureType = name;

    Query adventuresQuery = FirebaseFirestore.instance.collection('adventure').where("typeOfAdventure", isEqualTo: adventureType);



    // Apply filtering based on gender
    if (_genderFilter != 'All') {
      adventuresQuery = adventuresQuery.where('Gender', isEqualTo: _genderFilter);
    }


    // Apply filtering based on difficulty
    if (_difficultyFilter != 'All') {
      adventuresQuery = adventuresQuery.where('levelOfDifficulty', isEqualTo: _difficultyFilter);
    }

    // Update the _adventuresStream with the modified query
    setState(() {
      _adventuresStream = adventuresQuery.snapshots();



    });

  }
}


class ReusableCard extends StatefulWidget {


  final DateTime adventureCreationDate;
  final String  adventureID;
  final String uuid;
  final String count;
  final String adventureProviderName;
  final String typeOfAdventure;
  final String adventureDescription;
  final String phoneNumber;
  final String difficultyLevel;

  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;


  final String onlyFamilies;
  final String adventureNature;
  final String age;
  final String gender;

  final String equipmentProvided;
  final String freeAdventure;
  final String price;
  final String maxNumberOfParticipants;
  final String googleMapsLink;
  final String locationName;

 // int _currentPage = 0;

  final List<String> _images = [
    'assets/images/hiking.jpg',
    'assets/images/horseback.jpg',
    'assets/images/mountain.png',
    'assets/images/cycling.jpg',
  ];

  ReusableCard({
    required this.adventureCreationDate,
    required this.adventureID,
    required this.uuid,
    required this.count,
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
    required this.gender,
    required this.age,

    required this.equipmentProvided,
    required this.freeAdventure,
    required this.price,
    required this.maxNumberOfParticipants,
    required this.googleMapsLink,
    required this.locationName,

  });

  @override
  _ReusableCardState createState() => _ReusableCardState();
}

class _ReusableCardState extends State<ReusableCard> {
  int _currentPage = 0;



  @override
  Widget build(BuildContext context) {

    DateTime adventureCreationDate = widget.adventureCreationDate;
    String adventureID = widget.adventureID;
    String uuid = widget.uuid;
    String count = widget.count;
    String adventureProviderName = widget.adventureProviderName;
    String typeOfAdventure = widget.typeOfAdventure;
    String adventureDescription = widget.adventureDescription;
    String phoneNumber = widget.phoneNumber;
    String difficultyLevel = widget.difficultyLevel;

    String startDate = widget.startDate;
    String endDate = widget.endDate;
    String startTime = widget.startTime;
    String endTime = widget.endTime;

    String onlyFamilies = widget.onlyFamilies;
    String adventureNature = widget.adventureNature;
    String age = widget.age;
    String gender = widget.gender;

    String equipmentProvided =  widget.equipmentProvided;
    String freeAdventure = widget.freeAdventure;
    String price = widget.price;
    String maxNumberOfParticipants = widget.maxNumberOfParticipants;
    String googleMapsLink = widget.googleMapsLink;
    String locationName = widget.locationName;
    List<String> images = widget._images;




    // Parse the string into a DateTime object using a custom format
    List<String> dateParts = endDate.split('/');
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);
    DateTime formatedendDate = DateTime(year, month, day);

    print('Original Date String: $formatedendDate');

    DateTime currentDate = DateTime.now();

    // Compare the two DateTime objects
    if (formatedendDate.isBefore(currentDate)) {
      print('The converted date is before the current date.');
    } else if (formatedendDate.isAfter(currentDate)) {
      print('The converted date is after the current date.');
    } else {
      print('The converted date is the same as the current date.');
    }

    return GFCard(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.all(3.0),
      buttonBar: GFButtonBar(
        children: <Widget>[
          //icons
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 3),
                      // difficultyLevel
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.accessibility, color: Color(0xFF700464)),
                          difficultyLevel != "" ? Text(difficultyLevel) : const Text(''),
                        ],
                      ),
                      const SizedBox(height: 3),
                      // adventureNature
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.people, color: Color(0xFF700464)),
                          adventureNature != "" ? Text(adventureNature) : const Text(''),
                        ],
                      ),
                      const SizedBox(height: 3),
                      // Gender
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            const Icon(Icons.groups, color: Color(0xFF700464)),
                            gender != "" ? Text(" $gender") : const Text(''),
                        ],
                      ),
                      const SizedBox(height: 3),
                      // endDate
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.date_range, color: Color(0xFF700464)),
                          endDate != "" ? Text('End Date: $endDate') : const Text(''),
                        ],
                      ),
                    ]
                ),
                const Spacer(),
                // Images
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      Container(
                        width: 150,
                        height: 100,
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
                              children: images.asMap().entries.map((entry) {
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
                                              itemCount: images.length,
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

                                                       height:400,
                                                      width: double.infinity,
                                                       color: Colors.black, // Background color behind the image
                                                      child: Image.asset(
                                                        images[index],
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
                                                          borderRadius: BorderRadius.circular(3.0),
                                                        ),
                                                        child: Text(
                                                          '${index + 1} / ${images.length}',
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
                                            width: 150,
                                            height: 100,
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
                                              '${index + 1} / ${images.length}',
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



                    ]
                )
              ]
          ),

          const SizedBox(height: 8, ),
          // Price -- Location -- Let's do it
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Price
              ElevatedButton(
                onPressed: null,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
                child: Text(
                  price ?? '',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              const Spacer(),
             // Location
              ElevatedButton(
                onPressed: () {
                  final snackBar = SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: const Text('Do you want to open the location in Google Maps?'),
                    action: SnackBarAction(
                      label: 'Open' ,
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
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    side: const BorderSide(color: Color(0xFF700464)),
                  ),
                  backgroundColor: Colors.white,
                  elevation: 5,
                ),
                child: const Icon(Icons.location_on_outlined, size: 30, color: Color(0xFF700464)),
              ),
              const Spacer(),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Stack(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        User? user = FirebaseAuth.instance.currentUser;
                        String userID = "";

                        // Parse the string into a DateTime object using a custom format
                        List<String> dateParts = endDate.split('/');
                        int year = int.parse(dateParts[0]);
                        int month = int.parse(dateParts[1]);
                        int day = int.parse(dateParts[2]);
                        DateTime formatedendDate = DateTime(year, month, day);

                        print('Original Date String: $formatedendDate');

                        DateTime currentDate = DateTime.now();

                        // Compare the two DateTime objects
                        if (formatedendDate.isBefore(currentDate)) {
                          print('The converted date is before the current date.');
                        } else if (formatedendDate.isAfter(currentDate)) {
                          print('The converted date is after the current date.');
                        } else {
                          print('The converted date is the same as the current date.');
                        }

                        if (user != null ) {
                          userID = user.uid;
                          print('Current User ID: $userID');
                          // Navigate to My Custom Form

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyCustomForm(

                                // ----- This Goes to the Next Screen for confirmation
                                adventureCreationDate : adventureCreationDate,
                                uuid :uuid,
                                adventureID :adventureID,
                                count    :count,
                                adventureProviderName  :adventureProviderName,
                                typeOfAdventure  :typeOfAdventure,
                                adventureDescription:adventureDescription,
                                phoneNumber:phoneNumber,
                                difficultyLevel :difficultyLevel,

                                startDate :startDate,
                                endDate:endDate,
                                startTime:startTime,
                                endTime:endTime,

                                onlyFamilies:onlyFamilies,
                                adventureNature:adventureNature,
                                age:age,
                                gender:gender,

                                equipmentProvided: equipmentProvided,
                                freeAdventure:freeAdventure,
                                price:price,
                                maxNumberOfParticipants: maxNumberOfParticipants ,
                                googleMapsLink:googleMapsLink,
                                locationName:locationName,
                                images : images,

                              ),
                            ),
                          );
                        } else if (user == null) {
                          print('No user is currently logged in.');
                          // User is not logged in, show an alert
                          _logout(context);
                        }
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          side: const BorderSide(color:  Colors.white,),
                        ),
                        backgroundColor:  Color(0xFF700464),
                        elevation: 5,
                      ),
                      child: const Text(
                        "View",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )

            ],
          ),

          // Location Name
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Align(
                alignment: Alignment.center,
                // Location Name
                child: Text(
                  locationName ?? '',
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                ),
              ),
              const Spacer(),
            ],
          )
        ],
      ),
    );
  }

  // Create a function to handle logout
  Future<void> _logout(BuildContext context) async {
    try {
      // Clear cached user data
      await _clearCachedUserData();
      // Sign out of Firebase
      await FirebaseAuth.instance.signOut();

      // Navigate to the login screen or any other desired screen
      FirebaseAuth auth = FirebaseAuth.instance;
      auth.signOut().then((res) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SignUp()),
                (Route<dynamic> route) => false);
      });

      // Replace '/login' with your desired route
    } catch (e) {
      print("Error during logout: $e");
    }
  }

// Function to clear cached user data
  Future<void> _clearCachedUserData() async  {

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.clear(); // Clear all cached data
      print("Cached user data cleared");

    } catch (e) {
      print("Error clearing cached user data: $e");
    }

  }


}







