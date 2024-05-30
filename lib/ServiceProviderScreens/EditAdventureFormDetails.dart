import 'dart:async';
import 'dart:io';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'DisplayFullGoogleMaps.dart';
import 'package:uuid/uuid.dart';
/// Firebase Packages
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_datetime_picker/src/datetime_picker_theme.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../components/CustomAlertUI.dart';


/// Initialize Firebase
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( const EditAdventureForm());
}

class EditAdventureForm extends StatelessWidget {
  const EditAdventureForm({Key? key}) : super(key: key);
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  EditAdventureFormScreen(),
    );
  }
}

class EditAdventureFormScreen extends StatefulWidget {
  const EditAdventureFormScreen({Key? key}) : super(key: key);
  @override
  EditAdventureFormScreenState createState() => EditAdventureFormScreenState();
}

class EditAdventureFormScreenState extends State<EditAdventureFormScreen> {

  int _activeCurrentStep = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController adventureProviderName = TextEditingController();
  TextEditingController adventureDescription = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController adventureTypeController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController maxNumController = TextEditingController();
  TextEditingController locationName = TextEditingController();
  TextEditingController locationLink = TextEditingController();

  TextEditingController adventureLocationName = TextEditingController();
  TextEditingController gatheringLocationName = TextEditingController();
  TextEditingController adventureLocationLink = TextEditingController();
  TextEditingController gatheringLocationLink = TextEditingController();

  DateTime _dateTimeStart = DateTime.now();
  DateTime _dateTimeEnd = DateTime(2025, 1, 1, 00, 00);


  @override
  void initState() {
    super.initState();
    adventureLocationLink.addListener(_printLatestValue);
    gatheringLocationLink.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    adventureDescription.dispose();
    adventureLocationLink.dispose();
    gatheringLocationLink.dispose();
    super.dispose();
  }

  void _printLatestValue() {
    print('Text changed: ${adventureLocationLink.text}');
    print('Text changed: ${gatheringLocationLink.text}');
  }


  // To store the uploaded image
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  final List<File> _images = [];
  late List<String> imageUrls;
  final ImagePicker _picker = ImagePicker();

  Future<void> imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _images.add(File(pickedFile.path));
        uploadImagesToFirebase(_images);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  Future<void> imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _images.add(File(pickedFile.path));
        uploadImagesToFirebase(_images);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  Future<List<String>> uploadImagesToFirebase(List<File> images) async {
    final List<String> imageUrls = [];

    // Generate a UUID for the adventure
    final adventureID =  const Uuid().v4();

    for (int i = 0; i < images.length; i++) {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/adventure_$adventureID/image_$i.jpg');

      await ref.putFile(images[i]!);

      final downloadURL = await ref.getDownloadURL();
      imageUrls.add(downloadURL);
    }

    return imageUrls;
  }

  //Camera Button Picker
  void _showPicker(context) {

    if (_images.length >= 3) {
      // Show a message or alert indicating that the user can only select up to three images.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:  const Text('Oops'),
            content:  const Text('You can only select up to three images.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child:  Text("OK", style: TextStyle(color: Colors.blue[900])),
              ),
            ],
          );
        },
      );
      return;
    }

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading:    const Icon(Icons.photo_library),
                    title:   const Text('Gallery'),
                    onTap: () {
                      imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading:   const Icon(Icons.photo_camera),
                  title:   const Text('Camera'),
                  onTap: () {
                    imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
  // Remove Image from Firebase
  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

// to show the image in a bigger view
  void _showImageDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: 300,
            height: 300,
            child: Image.file(
              _images[index],
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }

  late  String   startDate = _dateTimeStart != null
      ? '${_dateTimeStart.year}/${_dateTimeStart.month}/${_dateTimeStart.day}'
      : "Not set";
  late  String    endDate = _dateTimeEnd != null
      ? '${_dateTimeEnd.year}/${_dateTimeEnd.month}/${_dateTimeEnd.day}'
      : "Not set";

  late String startTime = _dateTimeStart != null
      ? '${_dateTimeStart.hour.toString().padLeft(2, '0')}:${_dateTimeStart.minute.toString().padLeft(2, '0')}'
      : "Not set";

  late String endTime = _dateTimeEnd != null
      ? '${_dateTimeEnd.hour.toString().padLeft(2, '0')}:${_dateTimeEnd.minute.toString().padLeft(2, '0')}'
      : "Not set";


  bool light = false;
  bool _showTextField = true;
  bool _showTextFieldforFreeAdventure = true;
  // Is afventure submitted
  bool _isSubmitting = false;
  // Initial Selected Value
  String adventuresdropdown = 'Not set';
  // List of items in our dropdown menu
  var items = [
    'Not set',
    'Hiking',
    'Horse Riding',
    'Beach Adventure',
    'Cycling',
  ];

  DateTime now = DateTime.now();

  // String adventurePrice = "";

  // Time and date picker
  late DateTime selectedDateTime;
  bool pressed = false;
  // form button
  bool isLoading = false;
  // gender buttons
  int _value = 0;
  int adventureValue = 0;
  int _age = 0;
  int _diffLevel = 0;

  // Those variables to be printed/stored and sent to db
  // String provider_Name = "";
  String difficultyLevel = 'Easy';

  String easy = 'Easy';
  String moderate = 'Moderate';
  String challenging = 'Challenging';

  String onlyFamilies = 'Open Adventure';

  String  equipmentProvided = 'No, equipment not provided';

  bool isEquipmentProvided = false;// Initial state is "No"

  String adventureNature = 'Group Adventure';
  String gender = 'Both genders';
  String age = '+12';

  late String lat = '';
  late String long = '';
  late String googleMapsLink = '';
  //late String locationName = '';

  bool isAdventureFree = false; // initialize the checkbox value
  String freeAdventure = '';

  // final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter();

  final Color _textColor =  Colors.black;
  final Color _textColorWhite = Colors.white;




  /// ---------------- Validating the Text Fields ---------------------
  validateTextFields(String value) {
    setState(() {
      phoneNumlength = value.length;
    });

    if (value.isEmpty) {
      return 'Please enter a username';
    }
    return null;

  }
  /// ---------------- Text Field Max length Alart Phone Number----------------------
  int phoneNumlength = 0;
  _onChangedPhone(String value) {
    setState(() {
      phoneNumlength = value.length;
    });

    if (phoneNumlength == 8) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:  const Text('Opps '),
            content:  const Text("You have reached the maximum digits for phone number"),
            actions: <Widget>[
              TextButton(
                // color: Colors.blue[900],
                child:   const Text("OK", textAlign: TextAlign.center, style:  TextStyle(color: Colors.white) ) ,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  /// ---------------- Text Field Max length Alart Phone Number----------------------
  int maxNumPartici = 0;
  _onChangedMaxNum(String value) {
    setState(() {
      maxNumPartici = value.length;
    });

    if (maxNumPartici == 5) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:  const Text('Opps '),
            content:  const Text("You have reached the maximum number of participants"),
            actions: <Widget>[
              TextButton(
                // color: Colors.blue[900],
                child:   const Text("OK", textAlign: TextAlign.center, style:  TextStyle(color: Colors.white) ) ,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
  ///------------------------------------------------------------------------------

  List<Step> stepList() => [
    // Service Provider Details
    Step(
      state: _activeCurrentStep <= 0 ? StepState.editing : StepState.complete,
      isActive: _activeCurrentStep >= 0,
      title:  const Text('Service Provider Details'),
      content: Column(
        children: [
          const SizedBox(height: 8,),
          // Adventure Provider Name
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue[900]!, width: 0.5),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: ListTile(
                leading:  Icon(Icons.person_rounded, color: Colors.blue[900]),
                title: TextField(
                  keyboardType: TextInputType.name,
                  controller: adventureProviderName,
                  maxLines: 1,
                  decoration:  InputDecoration(
                      hintText:  "Adventure provider",
                      hintStyle: TextStyle(color: Colors.grey[400])
                  ),
                ),
              ),
            ),
          ),
          //  Type of Adventure
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: ListTile(
                  leading: Icon(Icons.category, color: Colors.blue[900] ),
                  title: const Text('Type of Adventure',
                      style: TextStyle(
                        fontSize: 15,
                      ))
              )
          ),
          Padding(
            padding:  const EdgeInsets.fromLTRB(2, 10, 2,10),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue[900]!, width: 0.5),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: ListTile(
                title: DropdownButton(
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  underline: Container(),
                  style:  TextStyle(color: Colors.blue[900],
                  ),
                  // Initial Value
                  value: adventuresdropdown,
                  // Down Arrow Icon
                  icon:  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: Icon(Icons.keyboard_arrow_down, color: Colors.blue[900], size: 30, )
                  ),
                  isExpanded: true,
                  // Array list of items
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(items, textAlign: TextAlign.center)
                      ),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      adventuresdropdown = newValue!;
                      // Validation check
                      if (adventuresdropdown == 'Not set') {
                        const Text(
                          'Please select a type of adventure',
                          style: TextStyle(color: Colors.red),
                        );
                      }
                    });
                  },
                ),


              ),
            ),
          ),

          // Adventure Description
          Padding(
            padding:  const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue[900]!, width: 0.5),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: ListTile(
                leading:  Icon(Icons.description, color: Colors.blue[900] ),
                title: TextField(
                  controller: adventureDescription,
                  //   onChanged: (AdventureDescrip) { adventureDescription = AdventureDescrip;},
                  keyboardType: TextInputType.multiline,

                  minLines: 3, //Normal textInputField will be displayed
                  maxLines: 20, // when user presses enter it will adapt to it
                  decoration:  InputDecoration(
                    hintText: "Adventure Description",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue[900]!),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Phone
          Padding(
            padding:  const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue[900]!, width: 0.5),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: ListTile(
                leading:  Icon(Icons.phone, color: Colors.blue[900]),
                title: TextField(
                  keyboardType: TextInputType.phone,
                  maxLength: 8,
                  controller: phoneController,
                  onChanged: (userPhone) {
                    if (_onChangedPhone == true) {
                      phoneController.text = userPhone;
                    }
                  },
                  decoration:  InputDecoration(
                    hintText: "Phone",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue[900]!),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Level of Difficulty
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: ListTile(
                leading: Icon(Icons.accessibility, color: Colors.blue[900]),
                title: const Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text("Difficulty level:"),
                    ]
                ),
              )
          ),
          // Level of Difficulty
          Padding(
            padding:  const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  //Easy
                  GestureDetector(
                    // onTap: () => setState(() => _diffLevel = 0),
                    onTap: () => setState(() {
                      _diffLevel = 0;
                      if (_diffLevel == 0) {
                        difficultyLevel = 'Easy';
                        if (kDebugMode) {
                          print(difficultyLevel);
                        }
                      }
                    }),


                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            // spreadRadius: 5,
                            // blurRadius: 14,
                            // offset:  const Offset(4, 8),
                          ),
                        ],
                        border: Border.all(
                          color:  Colors.blue[900]!,
                          width: 1.0,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(40.0),
                        color: _diffLevel == 0 ?  Colors.blue[900] : Colors.transparent,
                      ),
                      height: 50,
                      width: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Easy",
                            style: TextStyle(fontWeight: FontWeight.bold,  fontSize: 15, color: _diffLevel == 0 ? _textColorWhite : _textColor ),
                          ), // text
                        ],
                      ),
                    ),
                  ),
                  //Moderate
                  GestureDetector(
                    //   onTap: () => setState(() =>  _diffLevel = 1),
                    onTap: () => setState(() {
                      _diffLevel = 1;
                      if (_diffLevel == 1) {
                        difficultyLevel = 'Moderate';
                        if (kDebugMode) {
                          print(difficultyLevel);
                        }
                      }
                    }),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            //  spreadRadius: 5,
                            // blurRadius: 14,
                            // offset:  const Offset(4, 8), // changes position of shadow
                          ),
                        ],
                        border: Border.all(
                          color:  Colors.blue[900]!,
                          width: 1.0,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(40.0),
                        color:  _diffLevel == 1
                            ?  Colors.blue[900]
                            : Colors.transparent,
                      ),
                      height: 50,
                      width: 90,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  <Widget>[
                          Text(
                            "Moderate",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: _diffLevel == 1 ? _textColorWhite : _textColor ),
                          ), // text
                        ],
                      ),
                    ),
                  ),
                  //Challenging
                  GestureDetector(
                    //  onTap: () => setState(() =>  _diffLevel = 2),
                    onTap: () => setState(() {
                      _diffLevel = 2;
                      if (_diffLevel == 2) {
                        difficultyLevel = 'Challenging';
                        if (kDebugMode) {
                          print(difficultyLevel);
                        }
                      }
                    }),
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            // spreadRadius: 10,
                            // blurRadius: 14,
                            // offset:  const Offset(4, 8), // changes position of shadow
                          ),
                        ],
                        border: Border.all(
                          color:  Colors.blue[900]!,
                          width: 1.0,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(40.0),
                        color:  _diffLevel == 2 ?  Colors.blue[900] : Colors.transparent,
                      ),
                      height: 50,
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  <Widget>[
                          Text(
                            "Challenging",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: _diffLevel == 2 ? _textColorWhite : _textColor ),
                          ), // text
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),

    // Date and Time
    Step(
        state:
        _activeCurrentStep <= 1 ? StepState.editing : StepState.complete,
        isActive: _activeCurrentStep >= 1,

        title:  const Text('Date and Time'),
        content: Column(
          children: [
            // Starts Date
            Padding(
              padding:  const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Colors.blue[900],
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0)
                      ),
                    ),
                    onPressed: () {
                      pickDateTimeStart();
                    },

                    child: Container (
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.calendar_month_sharp,
                                    // size: 18.0,
                                    color: Colors.white,
                                  ),
                                  Text(' Start Date:  $startDate  - $startTime ', style:  const TextStyle(color: Colors.white)),

                                ],
                              )
                            ],
                          ),

                          const Icon(
                            Icons.edit,
                            // size: 18.0,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            // End Date
            Padding(
              padding:  const EdgeInsets.fromLTRB(0, 10, 0, 30),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Colors.blue[900],
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0)
                      ),
                    ),
                    onPressed: () {
                      pickDateTimeEnd();
                    },

                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.calendar_month_sharp,
                                    // size: 18.0,
                                    color: Colors.white,
                                  ),
                                  Text(' End Date:  $endDate   -   $endTime ', style:  const TextStyle(color: Colors.white)),

                                ],
                              )
                            ],
                          ),
                          const Icon(
                            Icons.edit,
                            // size: 18.0,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            /*
            // Start Time
            Padding(
              padding:  EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      elevation: 4.0,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)
                      ),
                    ),
                    onPressed: () {


                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                   Icon(
                                    Icons.access_time,
                                    // size: 18.0,
                                    color: Colors.white,
                                  ),
                                   Text('  Start Time:'),
                                  Text(
                                    "  $startTime",
                                    style:  TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0),
                                  ),
                                ],
                              )
                            ],
                          ),
                           Text(
                            "  Change",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            // End Time
            Padding(
              padding:  EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      elevation: 4.0,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)
                      ),
                    ),
                    onPressed: () {

                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                   Icon(
                                    Icons.access_time,
                                    // size: 18.0,
                                    color: Colors.white,
                                  ),
                                   Text('  End Time:'),
                                  Text(
                                    "  $endTime",
                                    style:  TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0),
                                  ),
                                ],
                              )
                            ],
                          ),
                           Text(
                            "  Change",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            */

          ],
        )),

    // Participants Details
    Step(
        state:
        _activeCurrentStep <= 1 ? StepState.editing : StepState.complete,
        isActive: _activeCurrentStep >= 2,

        title:  const Text('Participants Details'),
        content: Column(
          children: [
            //-Only Families:
            Padding(
              padding:  const EdgeInsets.fromLTRB(0, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Text( 'Only Families:',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold) ),
                  const Spacer(),
                  Switch(
                    activeColor:  Colors.blue[900],
                    inactiveThumbColor:  Colors.white,
                    inactiveTrackColor:   Colors.blue[900]!,
                    value: !_showTextField,
                    onChanged: (value) {
                      setState(() {
                        if (_showTextField = !_showTextField) {
                          onlyFamilies = 'Open Adventure';
                          if (kDebugMode) {
                            print(onlyFamilies);
                          }
                        } else  {
                          onlyFamilies = 'Only Families';
                          if (kDebugMode) {
                            print(onlyFamilies);
                          }
                        }
                      });
                    },
                  ),
                  Text(onlyFamilies),
                ],
              ),
            ),
            // Gender
            Padding(
              padding:  const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Visibility(
                visible: _showTextField,
                child:  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(  'Gender:',
                        style: TextStyle(fontSize: 15, ), textAlign: TextAlign.left,
                      ),
                    ] ),
              ),
            ),
            Padding(
              padding:  const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Visibility(
                visible: _showTextField,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      //onTap: () => setState(() => _value = 0),
                      onTap: () => setState(() {
                        _value = 0;
                        if (_value == 0) {
                          gender = 'Only Females';
                          if (kDebugMode) {
                            print(gender);
                          }
                        }
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              // spreadRadius: 5,
                              //  blurRadius: 14,
                              //  offset:  const Offset(4, 8),
                            ),
                          ],
                          border: Border.all(
                            color:   Colors.blue[900]!,
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(40.0),
                          color: _value == 0 ?   Colors.blue[900] : Colors.transparent,
                        ),
                        height: 70,
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.female, size: 40, color: _value == 0 ? _textColorWhite : _textColor ), // icon
                            Text(
                              "Females",
                              style: TextStyle(fontWeight: FontWeight.bold, color: _value == 0 ? _textColorWhite : _textColor ),
                            ), // text
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      // onTap: () => setState(() => _value = 1),
                      onTap: () => setState(() {
                        _value = 1;
                        if (_value == 1) {
                          gender = 'Only Males';
                          if (kDebugMode) {
                            print(gender);
                          }
                        }
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              // spreadRadius: 5,
                              // blurRadius: 14,
                              // offset:  const Offset(4, 8), // changes position of shadow
                            ),
                          ],
                          border: Border.all(
                            color:  Colors.blue[900]!,
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(40.0),
                          color: _value == 1 ?  Colors.blue[900] : Colors.transparent,
                        ),
                        height: 70,
                        width: 85,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.male, size: 40, color: _value == 1 ? _textColorWhite : _textColor ), // icon
                            Text(
                              "Males",
                              style: TextStyle(fontWeight: FontWeight.bold, color: _value == 1 ? _textColorWhite : _textColor ),
                            ), // text
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      // onTap: () => setState(() => _value = 2),
                      onTap: () => setState(() {
                        _value = 2;
                        if (_value == 2) {
                          gender = 'Both genders';
                          if (kDebugMode) {
                            print(gender);
                          }
                        }
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 14,
                              offset:  const Offset(4, 8), // changes position of shadow
                            ),
                          ],
                          border: Border.all(
                            color:  Colors.blue[900]!,
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(40.0),
                          color: _value == 2
                              ?  Colors.blue[900]
                              : Colors.transparent,
                        ),
                        height: 70,
                        width: 90,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.male, size: 40, color: _value == 2 ? _textColorWhite : _textColor ), // icon
                                Icon(Icons.female, size: 40, color: _value == 2 ? _textColorWhite : _textColor ),
                              ],
                            ),
                            // icon
                            Text(
                              "Mix",
                              style: TextStyle(fontWeight: FontWeight.bold, color: _value == 2 ? _textColorWhite : _textColor),
                            ), // text
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Adventure Nature
            Padding(
              padding:  const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Visibility(
                visible: _showTextField,
                child:  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('Adventure Nature:',
                        style: TextStyle(fontSize: 15, ), textAlign: TextAlign.left,
                      ),
                    ] ),
              ),
            ),
            Padding(
                padding:  const EdgeInsets.fromLTRB(0, 0, 0,  0),
                child: Visibility(
                  visible: _showTextField,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      GestureDetector(
                        // onTap: () => setState(() => adventureValue = 0),
                        onTap: () => setState(() {
                          adventureValue = 0;
                          if (adventureValue == 0) {
                            adventureNature = 'Group Adventure';
                            if (kDebugMode) {
                              print(adventureNature);
                            }
                          }
                        }),

                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                // spreadRadius: 5,
                                // blurRadius: 14,
                                //  offset:  const Offset(4, 8),
                              ),
                            ],
                            border: Border.all(
                              color:  Colors.blue[900]!,
                              width: 1.0,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(40.0),
                            color: adventureValue == 0 ?  Colors.blue[900]  : Colors.transparent,
                          ),
                          height: 80,
                          width: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:   <Widget>[
                              Icon(Icons.groups, size: 40,  color: adventureValue == 0 ? _textColorWhite : _textColor), // icon
                              Text(
                                "Group Adventure",
                                style: TextStyle(fontWeight: FontWeight.bold,  fontSize: 12,  color: adventureValue == 0 ? _textColorWhite : _textColor),
                              ), // text
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        //  onTap: () => setState(() => adventureValue = 1),
                        onTap: () => setState(() {
                          adventureValue = 1;
                          if (adventureValue == 1) {
                            adventureNature = 'Individual Adventure';
                            if (kDebugMode) {
                              print(adventureNature);
                            }
                          }
                        }),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                // spreadRadius: 5,
                                //  blurRadius: 14,
                                //  offset:  const Offset(4, 8), // changes position of shadow
                              ),
                            ],
                            border: Border.all(
                              color:  Colors.blue[900]!,
                              width: 1.0,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(40.0),
                            color: adventureValue == 1
                                ?  Colors.blue[900]
                                : Colors.transparent,
                          ),
                          height: 80,
                          width: 160,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:  <Widget>[
                              Icon(Icons.person, size: 40,  color: adventureValue == 1 ? _textColorWhite : _textColor), // icon
                              Text(
                                "Individual Adventure", textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,  color: adventureValue == 1 ? _textColorWhite : _textColor
                                ),
                              ), // text
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ),

            // age
            Padding(
              padding:  const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: ListTile(
                leading:  const Text("age:", style: TextStyle(fontSize: 15, ), textAlign: TextAlign.left,),
                title: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    //  Text("age:", style: TextStyle(fontSize: 15, ), textAlign: TextAlign.left,),
                    const SizedBox(width: 35),
                    GestureDetector(
                      //   onTap: () => setState(() => _age = 0),
                      onTap: () => setState(() {
                        _age = 0;
                        if (_age == 0) {
                          age = '+12';
                          if (kDebugMode) {
                            print(age);
                          }
                        }
                      }),

                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              // spreadRadius: 5,
                              //  blurRadius: 14,
                              // offset:  const Offset(4, 8),
                            ),
                          ],
                          border: Border.all(
                            color:  Colors.blue[900]!,
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(40.0),
                          color: _age == 0 ?  Colors.blue[900]  : Colors.transparent,
                        ),
                        height: 70,
                        width: 70,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "+12",
                              style: TextStyle(fontWeight: FontWeight.bold,  fontSize: 18, color: _age == 0 ? _textColorWhite : _textColor ),
                            ), // text
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      // onTap: () => setState(() =>  _age = 1),
                      onTap: () => setState(() {
                        _age = 1;
                        if (_age == 1) {
                          age = '+18';
                          if (kDebugMode) {
                            print(age);
                          }
                        }
                      }),

                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              //  spreadRadius: 5,
                              //  blurRadius: 14,
                              //  offset:  const Offset(4, 8), // changes position of shadow
                            ),
                          ],
                          border: Border.all(
                            color:  Colors.blue[900]!,
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(40.0),
                          color:  _age == 1
                              ?  Colors.blue[900]
                              : Colors.transparent,
                        ),
                        height: 70,
                        width: 70,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  <Widget>[
                            Text(
                              "+18",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: _age == 1 ? _textColorWhite : _textColor ),
                            ), // text
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    ),

    // Price & Location
    Step(
        state:
        _activeCurrentStep <= 1 ? StepState.editing : StepState.complete,
        isActive: _activeCurrentStep >= 3,

        title:  const Text('Price & Location'),
        content: Column(
          children: [
            Padding(
              padding:  const EdgeInsets.fromLTRB(0, 10, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Text( 'Is equipment provided?',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold) ),
                  const Spacer(),
                  Switch(
                    activeColor:  Colors.blue[900],
                    inactiveThumbColor:   Colors.white,
                    inactiveTrackColor:   Colors.blue[900]!,
                    value: isEquipmentProvided,
                    onChanged: (value) {
                      setState(() {
                        isEquipmentProvided = value;
                        if (isEquipmentProvided == false) {
                          equipmentProvided = 'No, equipment not provided';
                        }
                        if (kDebugMode) {
                          print(equipmentProvided);
                        }
                        if (isEquipmentProvided == true) {
                          equipmentProvided = 'Yes, equipment provided';
                          if (kDebugMode) {
                            print(equipmentProvided);
                          }
                        }
                      });
                    },
                  ),
                  //     Text(equipmentProvided),
                ],
              ),

            ),
            Padding(
              padding:  const EdgeInsets.fromLTRB(0, 0, 20, 10),
              child:  Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(equipmentProvided  ),
                  ]
              ),
            ),
            Padding(
              padding:  const EdgeInsets.fromLTRB(0, 10, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Text( 'Is free Adventure?',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold) ),
                  const Spacer(),
                  Switch(
                    activeColor:  Colors.blue[900],
                    inactiveThumbColor:   Colors.white,
                    inactiveTrackColor:   Colors.blue[900]!,
                    value: !_showTextFieldforFreeAdventure, // true by default
                    onChanged: (value) {
                      setState( () {
                        if (_showTextFieldforFreeAdventure = !_showTextFieldforFreeAdventure) {
                          freeAdventure = 'Not Free Adventure';
                          if (kDebugMode) {
                            print(freeAdventure);
                          }
                          priceController.text = " ";
                        } else  {
                          freeAdventure = "Free Adventure";
                          priceController.text = "0.0";
                          if (kDebugMode) {
                            print(freeAdventure);
                          }
                        }
                      } );
                    },
                  ),
                  //    Text(freeAdventure),
                ],
              ),
            ),
            Padding(
              padding:  const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child:  Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(freeAdventure  ),
                  ]
              ),
            ),
            //Price
            Padding(
              padding:  const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Visibility(
                visible: _showTextFieldforFreeAdventure,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue[900]!, width: 0.5),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ListTile(
                    leading:  Icon(Icons.monetization_on, color: Colors.blue[900]),
                    title:TextField(
                      inputFormatters:   <TextInputFormatter>[
                        CurrencyTextInputFormatter.currency (

                            locale: 'en_US',
                            decimalDigits: 0,
                            symbol: 'OMR ',
                            enableNegative: true
                        )
                      ],
                      keyboardType: TextInputType.number,
                      maxLength: 7,
                      controller: priceController,

                      onChanged: (adventurePrice) {
                        if (freeAdventure == "Free Adventure") {
                          priceController.text = "0.0";

                        }  if (freeAdventure == "Not Free Adventure") {
                          priceController.text = "";
                          priceController.text =  adventurePrice ;
                        }
                      },


                      decoration:  InputDecoration(
                        hintText: "Price",
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue[900]!),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Max Number of participants
            Padding(
              padding:  const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue[900]!, width: 0.5),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: ListTile(
                  leading:  Icon(Icons.groups, color: Colors.blue[900]),
                  title: TextField(
                    keyboardType: TextInputType.phone,
                    maxLength:4,
                    controller: maxNumController,
                    onChanged: (userMaxNum) {
                      if ( _onChangedMaxNum == true) {
                        maxNumController.text = userMaxNum;
                      }
                    },
                    decoration:  InputDecoration(
                      hintText: "Max Number of participants",
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue[900]!),
                      ),
                      focusedBorder:   UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Locations
            Padding (
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: ListTile(
                leading: Icon(Icons.my_location_sharp, color: Colors.blue[900]),
                title: const Text('Adventure Location:'),
              ),
            ),




            // Adventure Location Name
            Padding(
              padding:  const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue[900]!, width: 0.5),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextField(
                  keyboardType: TextInputType.name,
                  controller: adventureLocationName,
                  maxLines: 1,
                  decoration:    InputDecoration(
                    hintText:  "  Enter Adventure Location Name",
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                  ),
                ),
              ),
            ),
            // Gathering Location Name
            Padding(
              padding:  const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue[900]!, width: 0.5),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextField(
                  keyboardType: TextInputType.name,
                  controller: gatheringLocationName,
                  maxLines: 1,
                  decoration:    InputDecoration(
                    hintText:  "  Enter Gathering Location Name",
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                  ),
                ),
              ),
            ),
            // Adventure Location Link
            Padding(
              padding:  const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue[900]!, width: 0.5),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextField(
                  keyboardType: TextInputType.name,
                  controller: adventureLocationLink,
                  maxLines: 2,
                  decoration:    InputDecoration(
                    hintText:  "  Enter Adventure Location Link",
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                  ),
                ),
              ),
            ),
            // Gathering Location Link
            Padding(
              padding:  const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue[900]!, width: 0.5),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextField(
                  keyboardType: TextInputType.name,
                  controller:  gatheringLocationLink   ,
                  maxLines: 2,
                  decoration:    InputDecoration(
                    hintText:  "  Enter Gathering Location Link",
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                  ),
                ),
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: FloatingActionButton(
                          onPressed: () {
                            // Add onPressed functionality here.
                          },
                          backgroundColor: Colors.blue[100],
                          shape: const StadiumBorder(),
                          child: Icon(
                            Icons.map_outlined,
                            size: 50,
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            'Adventure Location',
                            style: TextStyle(
                              color: Colors.blue[900],
                            ),
                          ),
                          // Icon(Icons.outbound_outlined, color: Colors.blue[900]),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          adventureLocationLink.text.isEmpty
                              ? const Icon(Icons.cancel, color: Colors.red)
                              : const Icon(Icons.check_circle, color: Colors.green),
                          Text(
                            adventureLocationLink.text.isEmpty ? 'add location ' : 'added ',
                            style: TextStyle(
                              color: Colors.blue[900],
                            ),
                          ),
                          //    Icon(Icons.outbound_outlined, color: Colors.blue[900]),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: FloatingActionButton(
                          onPressed: () {
                            // Add onPressed functionality here.
                          },
                          backgroundColor: Colors.blue[100],
                          shape: const StadiumBorder(),
                          child: Icon(
                            Icons.location_on_outlined,
                            size: 50,
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            'Gathering Location',
                            style: TextStyle(
                              color: Colors.blue[900],
                            ),
                          ),
                          //    Icon(Icons.outbound_outlined, color: Colors.blue[900]),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          gatheringLocationLink.text.isEmpty
                              ? const Icon(Icons.cancel, color: Colors.red)
                              : const Icon(Icons.check_circle, color: Colors.green),
                          Text(
                            gatheringLocationLink.text.isEmpty ? 'add location ' : 'added ',
                            style: TextStyle(
                              color: Colors.blue[900],
                            ),
                          ),
                          //    Icon(Icons.outbound_outlined, color: Colors.blue[900]),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),


            /*
            // Get the Map Link
            Padding (
              padding:  EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: ListTile(
                leading:  Icon(Icons.location_on,),
                title:  Text('Gathering Point:'),
                trailing:  ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue[900]),
                  ),
                  child:  Text('Add a location '),
                  onPressed: () async {
                    List<dynamic>? result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapPickerScreen()),
                        //
                    );
                    if (result != null) {
                      String variable1 = result[0];
                      String variable2 = result[1];
                      String variable3 = result[2];
                      print('Aqui Variable 1: $variable1');
                      print('Aqui Variable 2: $variable2');
                      print('Aqui Variable 3: $variable3');

                      Lat = variable1;
                      Long = variable2;
                      locationName = variable3;

                      print('Aqui Variable 1: $Lat');
                      print('Aqui Variable 2: $Long');
                      googleMapsLink = 'https://www.google.com/maps/search/?api=1&query=$Lat,$Long';
                      print('Google Maps Link: $googleMapsLink');
                    }
                  }, // press

                ),
              ),
            ),

           */

          ],
        )
    ),
    // Upload Photos
    Step(
      state:
      _activeCurrentStep <= 1 ? StepState.editing : StepState.complete,
      isActive: _activeCurrentStep >= 4,
      title:  const Text('Upload Photos'),
      content: Column(
        children: [
          const SizedBox(height: 20),
          Text('Total of Uploaded Images: ${_images.length}'),
          const SizedBox(height: 20),
          Row(
            children: [
              for (int index = 0; index < _images.length; index++)
                Padding(
                  padding:  const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                        child: Image.file(
                          _images[index],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            _removeImage(index);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding:  const EdgeInsets.all(4),
                              color: Colors.red,
                              child:  const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(

                onPressed: () {_showPicker(context);}, style: ButtonStyle(elevation: MaterialStateProperty.all(10)),
                child:  const Text("Add Photos"),

              )
            ],
          ),
        ],
      ),

    ),
     // Confirmation
    Step(
      state: StepState.complete,
      isActive: _activeCurrentStep >= 5,
      title:  const Text('Confirmation'),
      content: Card(
        color:  Colors.white70,
        elevation: 4, // Add elevation for a card-like appearance
        margin:  const EdgeInsets.all(12.0), // Add some margin for spacing
        child: Padding(
          padding:  const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Step 1 Service Provider Details
              const Text(
                'Service Provider Details',
                style: TextStyle(fontWeight: FontWeight.bold , decoration: TextDecoration.underline),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8,),
              const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Adventure provider: '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),

                  ]
              ),
              Text(adventureProviderName.text  ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Adventure Type: '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),
                    Text(adventuresdropdown  ),
                  ]
              ),
              const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Adventure Description:  '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),

                  ]
              ),
              Text(adventureDescription.text  ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Phone Number:  '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),
                    Text(phoneController.text  ),
                  ]
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Level of Difficulty:  '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),
                    Text(difficultyLevel  ),
                  ]
              ),
              // Step 2 Date and Time
              const Divider(), // Add a divider for separation
              const Text(
                'Date and Time',
                style: TextStyle(fontWeight: FontWeight.bold,   decoration: TextDecoration.underline  ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8,),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Start Date:   '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),
                    Text(startDate  ),
                  ]
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('End Date:     '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),
                    Text(endDate  ),
                  ]
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Start Time:  '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),
                    Text(startTime  ),
                  ]
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('End Time:    '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),
                    Text(endTime  ),
                  ]
              ),
              // Step 3 Participants Details
              const Divider(),
              const Text(
                'Participants Details',
                style: TextStyle(fontWeight: FontWeight.bold , decoration: TextDecoration.underline),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8,),

              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Is Only Family:  '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),
                    Text(onlyFamilies  ),
                  ]
              ),

              const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Adventure Nature:  '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),

                  ]
              ),
              Text(adventureNature  ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Gender: '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),
                    Text(gender),
                  ]
              ),

              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('age: '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),
                    Text(age),
                  ]
              ),

              // Step 4 Price & Location
              const Divider(),
              const Text(
                'Price & Location',
                style: TextStyle(fontWeight: FontWeight.bold , decoration: TextDecoration.underline),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8,),
              const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Is Equipment Provided:  '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),
                  ]
              ),

              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(equipmentProvided  ),
                  ]
              ),

              const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Is Free Adventure:  '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),

                  ]
              ),

              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(freeAdventure  ),
                  ]
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Price:  '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),
                    Text(priceController.text  ),
                  ]
              ),
              const SizedBox(height: 10),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Max Number of Participants:  '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),
                    Text(maxNumController.text  ),
                  ]
              ),
              const SizedBox(height: 10),


              // adventureLocationName.text,
              const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Adventure Location Name:  '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),

                  ]
              ),
              Text(adventureLocationName.text,  ),
              const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Adventure Location Link '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),

                  ]
              ),
              Text( adventureLocationLink.text),

              const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Gathering Location Name:  '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),

                  ]
              ),
              Text( gatheringLocationName.text ),
              const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Gathering Location Link:  '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),

                  ]
              ),
              Text(gatheringLocationLink.text, ),

              const SizedBox(height: 10),
              const Divider(),
              const Text(
                'Images',
                style: TextStyle(fontWeight: FontWeight.bold , decoration: TextDecoration.underline),
                textAlign: TextAlign.center,
              ),
              Row(
                children: [
                  for (int index = 0; index < _images.length; index++)
                    Padding(
                      padding:  const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          _showImageDialog(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: Stack(
                            children: [
                              Image.file(
                                _images[index]!,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),

            ],
          ),
        ),
      ),
    )


  ];



// The Actual Stepper

  @override
  Widget build(BuildContext context) {



    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        elevation: 3,
        title:  const Text(
            'Adventure Form',
            style: TextStyle(  fontSize: 25,
              fontStyle: FontStyle.normal,
              color: Colors.black,
            )
        ),

      ),
      body: Stack(
        children: [

          Theme(
            data: ThemeData(
              colorScheme: ColorScheme.fromSwatch().copyWith(primary:  Colors.blue[900], secondary:  Colors.blue[900] ),
            ),
            child: Stepper(
              type: StepperType.vertical,
              physics:  const ScrollPhysics(),
              currentStep: _activeCurrentStep,
              steps: stepList(),
              controlsBuilder: (BuildContext context, ControlsDetails controlsDetails) {
                if (_activeCurrentStep == 0) {
                  return Row(
                    children: <Widget>[
                      const Spacer(),
                      ElevatedButton(
                        onPressed: controlsDetails.onStepContinue,
                        child:  const Text('NEXT'),
                      ),
                      const SizedBox(width: 8.0),
                    ],
                  );
                } else if (_activeCurrentStep == stepList().length - 1) {
                  return Row(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: controlsDetails.onStepCancel,
                        child:  const Text('BACK'),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          // ----------- Validation ----------------------
                          // Validate the required text fields
                          if (adventureProviderName.text == '' ||
                              adventureProviderName.text.isEmpty ||
                              adventuresdropdown.isEmpty ||
                              adventureDescription.text.isEmpty ||
                              phoneController.text.isEmpty ||
                              priceController.text.isEmpty ||
                              maxNumController.text.isEmpty ||
                              maxNumController.text == "" ||
                              gender.isEmpty ||
                              gender == "" ||
                              age.isEmpty ||
                              age.isEmpty ||
                              adventureNature.isEmpty ||

                              //  locationName.text.isEmpty ||
                              //   locationName.text == "" ||

                              //   locationLink.text.isEmpty ||
                              //   locationLink.text == "" ||

                              adventureLocationName.text.isEmpty ||
                              gatheringLocationName.text.isEmpty ||

                              adventureLocationLink.text.isEmpty ||
                              gatheringLocationLink.text.isEmpty ||

                              adventureLocationName.text == "" ||
                              gatheringLocationName.text == ""  ||

                              adventureLocationLink.text == "" ||
                              gatheringLocationLink.text == ""

                          ) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text('Please fill all required fields'),
                                  backgroundColor: Colors.red, // set the background color to red
                                )
                            );
                            setState(() {
                              _isSubmitting = false;
                            });
                            return;
                          }
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor:  Colors.white,
                                title:  Text('Your Adventure Details',
                                  style: TextStyle(fontWeight: FontWeight.bold , color: Colors.blue[900] ),
                                  textAlign: TextAlign.center, ),

                                content: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // Step 1 Service Provider Details
                                      const Text(
                                        'Service Provider Details',
                                        style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                                        textAlign: TextAlign.center,

                                      ),
                                      const SizedBox(height: 8,),

                                      const Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('Adventure provider: '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),

                                          ]
                                      ),
                                      Text(adventureProviderName.text  ),
                                      Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const Text('Adventure Type: '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),
                                            Text(adventuresdropdown  ),
                                          ]
                                      ),
                                      const Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('Adventure Description:  '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),

                                          ]
                                      ),
                                      Text(adventureDescription.text  ),
                                      Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const Text('Phone Number:  '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),
                                            Text(phoneController.text  ),
                                          ]
                                      ),
                                      Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const Text('Level of Difficulty:  '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),
                                            Text(difficultyLevel  ),
                                          ]
                                      ),
                                      // Step 2 Date and Time
                                      const Divider(), // Add a divider for separation
                                      const Text(
                                        'Date and Time',
                                        style: TextStyle(fontWeight: FontWeight.bold,   decoration: TextDecoration.underline ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8,),
                                      Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const Text('Start Date:   '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),
                                            Text(startDate  ),
                                          ]
                                      ),

                                      Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const Text('End Date:     '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),
                                            Text(endDate  ),
                                          ]
                                      ),
                                      Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const Text('Start Time:  '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),
                                            Text(startTime  ),
                                          ]
                                      ),
                                      Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const Text('End Time:    '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),
                                            Text(endTime  ),
                                          ]
                                      ),

                                      // Step 3 Participants Details
                                      const Divider(),
                                      const Text(
                                        'Participants Details',
                                        style: TextStyle(fontWeight: FontWeight.bold , decoration: TextDecoration.underline),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8,),

                                      Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const Text('Is Only Family:  '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),
                                            Text(onlyFamilies  ),
                                          ]
                                      ),

                                      const Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('Adventure Nature:  '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),
                                          ]
                                      ),
                                      Text(adventureNature  ),
                                      Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const Text('Gender  '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),
                                            Text(gender  ),
                                          ]
                                      ),

                                      Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const Text('age  '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),
                                            Text(age),
                                          ]
                                      ),

                                      // Step 4 Price & Location
                                      const Divider(),
                                      const Text(
                                        'Price & Location',
                                        style: TextStyle(fontWeight: FontWeight.bold , decoration: TextDecoration.underline),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8,),
                                      const Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('Is Equipment Provided: '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),
                                          ]
                                      ),
                                      Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(equipmentProvided ),
                                          ]
                                      ),

                                      Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const Text('Is Free Adventure:  '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),
                                            Text(freeAdventure  ),
                                          ]
                                      ),

                                      Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const Text('Price:  '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),
                                            Text(priceController.text  ),
                                          ]
                                      ),

                                      Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const Text('Max Number of Participants:  '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),
                                            Text(maxNumController.text  ),
                                          ]
                                      ),





                                      // adventureLocationName.text,
                                      const Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('Adventure Location Name:  '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),

                                          ]
                                      ),
                                      Text(adventureLocationName.text,  ),
                                      const Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('Adventure Location Link '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),

                                          ]
                                      ),
                                      Text( adventureLocationLink.text),

                                      const Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('Gathering Location Name:  '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),

                                          ]
                                      ),
                                      Text( gatheringLocationName.text ),
                                      const Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('Gathering Location Link:  '  ,  style: TextStyle(fontWeight: FontWeight.bold) ),

                                          ]
                                      ),
                                      Text(gatheringLocationLink.text, ),


                                      const SizedBox(height: 10),

                                      const Divider(),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Attached Images',
                                        style: TextStyle(fontWeight: FontWeight.bold , decoration: TextDecoration.underline),
                                        textAlign: TextAlign.center,
                                      ),
                                      Row(
                                        children: [
                                          for (int index = 0; index < _images.length; index++)
                                            Padding(
                                              padding:  const EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  _showImageDialog(index);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.black,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius: BorderRadius.circular(3.0),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      Image.file(
                                                        _images[index]!,
                                                        width: 70,
                                                        height: 70,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // Perform your submit action
                                      _submitForm();
                                      Navigator.pop(context);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.white),
                                    ),
                                    child:  Text('Yes, Submit', style: TextStyle(color:Colors.blue[900] )),
                                  ),
                                  TextButton(

                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.white),
                                    ),
                                    child:  Text('No', style: TextStyle(color: Colors.blue[900]   )),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child:  const Text('SUBMIT'),
                      ),

                      const SizedBox(width: 8.0),
                    ],
                  );
                } else {
                  return Row(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: controlsDetails.onStepCancel,
                        child:  const Text('BACK'),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: controlsDetails.onStepContinue,
                        child:  const Text('NEXT'),
                      ),
                      const SizedBox(width: 8.0),
                    ],
                  );
                }

              },



              onStepContinue: () {
                if (_activeCurrentStep < (stepList().length - 1)) {
                  setState(() {
                    _activeCurrentStep += 1;
                  });
                }
              },
              onStepCancel: () {
                if (_activeCurrentStep == 0) {
                  return;
                }
                setState(() {
                  _activeCurrentStep -= 1;
                });
              },
              onStepTapped: (int index) {
                setState(() {
                  _activeCurrentStep = index;
                });
              },
            ),
          ),
          _isSubmitting // show the activity indicator when the form is being submitted
              ? Container(
              color: Colors.black54,
               child:  const Center(
                child: CircularProgressIndicator(  ),
            ),
          )
              :  Container(  ),

        ],
      ),
    );
  }

// ---------------------- To Firebase ----------------------



  Future<void> _submitForm() async {

    // Check for internet connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // No internet connection
      _showNoInternetDialog();
      return;
    }

    setState(() {
      _isSubmitting = true;

      if (priceController.text == "0.0") {
        freeAdventure = "Free Adventure";
      } else {
        freeAdventure == "Not Free Adventure";
      }


    });
/*
    Container(
      color: Colors.white,  // Set the background color to white
      child: Center(
        child: _isSubmitting
            ?  CircularProgressIndicator()
            : Container(
             // Your white box content
              width: 100.0,
              height: 100.0,
              color: Colors.white,
                child:  Text('Please Wait...'),
        ),
      ),
    );
*/
    // ----------- Validation ----------------------
/*
    if (locationLink == null || locationLink == "" ) {
      ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            content: Text('Please select a location for the adventure'),
            backgroundColor: Colors.red, // set the background color to red
          )
      );
      setState(() {
        _isSubmitting = false;
      });
      return;
    }
*/
/*
    if (googleMapsLink == null || googleMapsLink.isEmpty ) {
      ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            content: Text('Please select a location for the adventure'),
            backgroundColor: Colors.red, // set the background color to red
          )
      );
      setState(() {
        _isSubmitting = false;
      });
      return;
    }
*/
/*
    if (startDate == "Not set" || endDate == "Not set" || startTime == "Not set" || endTime == "Not set") {
      ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            content: Text('Please specify all the dates and times'),
            backgroundColor: Colors.red, // set the background color to red
          )
      );
      _isSubmitting = false;
    }

   * /

     */
/*
    print('=============Start TIME==================');
    DateTime startTime = DateFormat('hh:mm a').parse(startTime);
    print(startTime);

    print('=============END TIME==================');
    DateTime endTime = DateFormat('hh:mm a').parse(endTime);
    print(endTime);

    print('=============Start DATE==================');
    DateTime startDate = DateFormat('dd-MM-yyyy').parse(startDate);
    print(startDate);

    print('=============END DATE==================');
    DateTime endDate = DateFormat('dd-MM-yyyy').parse(endDate);
    print(endDate);


    if (startTime.hour == endTime.hour && startTime.minute == endTime.minute) {
      print(startTime.hour);
      print('Yes Start Time = End Time');
      print(endTime.hour);
      print(startTime.minute);
      print('Yes Start Time = End Time');
      print(endTime.minute);

      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text('The adventure must be at least one hour'),
          backgroundColor: Colors.red, // set the background color to red
        ),
      );
      setState(() {
        _isSubmitting = false;
      });
      return;
    }


// The adventure start time must be before end tim
    if (startDate.year == endDate.year &&
        startDate.month == endDate.month &&
        startDate.day == endDate.day &&
        startTime.isAfter(endTime) == true &&
        endTime.isBefore(startTime) ) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text('The adventure start time must be before end time'),
          backgroundColor: Colors.red, // set the background color to red
        ),
      );
      setState(() {
        _isSubmitting = false;
      });
      return;
    }

    if (startDate.year == endDate.year &&
        startDate.month == endDate.month &&
        startDate.day == endDate.day &&
        startTime.isAtSameMomentAs(endTime) == false) {
      // start date and end date are the same
      Duration duration = endTime.difference(startTime);
      if (duration.inMinutes < 60) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            content: Text('The adventure must be at least one hour'),
            backgroundColor: Colors.red, // set the background color to red
          ),
        );
        setState(() {
          _isSubmitting = false;
        });
        return;
      }
    }

*/

    if (kDebugMode) {
      print("I  am about  to submit this form ++++++++++++++++");
    }
    try {
      // Generate a UUID
      final uuid =  const Uuid().v4();
      if (kDebugMode) {
        print("I am trying to submit this form ++++++++++++++++");
      }
      // Increment the adventure count
      final doc = await FirebaseFirestore.instance.collection('adventure_count').doc('count').get();
      final count = doc.exists ? doc.data()!['count'] as int : 0;
      await FirebaseFirestore.instance.collection('adventure_count').doc('count').set({'count': count + 1});

      // Upload images to Firebase Storage
      final List<String> imageUrls = await uploadImagesToFirebase( _images );


      // Add the adventure data to Firestore with the UUID and count
      final adventureData = {

        'adventureCreationDate': DateTime.now(),
        'adventureID': uuid, // add the UUID to the map
        'adventureNumber': count + 1,
        'serviceProviderName': adventureProviderName.text,
        'typeOfAdventure': adventuresdropdown ,
        'adventureDescription': adventureDescription.text,
        'phoneNumber':phoneController.text,
        'levelOfDifficulty' : difficultyLevel ,
        'startDate' : startDate,
        'endDate': endDate,
        'startTime':  startTime,
        'endTime':endTime,
        'isOnlyFamily': onlyFamilies,
        'adventureNature' :  adventureNature,
        'gender' : gender ,
        'age': age ,
        "isEquipmentProvided" : equipmentProvided,
        "isFreeAdventure" : freeAdventure,
        'price' : priceController.text,
        'maxNumberOfParticipants' :  maxNumController.text,

        //    'googleMapsLink' : locationLink.text,
        //   'locationName' : locationName.text,


        'adventureLocationName' :  adventureLocationName.text,
        'gatheringLocationName' :  gatheringLocationName.text,
        'adventureLocationLink' :   adventureLocationLink.text,
        'gatheringLocationLink' :   gatheringLocationLink.text,

        'imageUrls': imageUrls,

        // 'Latitude ': Lat ,
        // 'Longitude ': Long ,
        // 'googleMapsLink ': googleMapsLink ,
        //'The name of the location ': locationName ,

      };

      await FirebaseFirestore.instance
          .collection('adventure')
          .add(adventureData);

      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Adventure submitted successfully'),
          ),
        );

        _isSubmitting = false;
        // After submission close the close screen
        // show a successful submission dialog
        showDialog(
          context: context,
          barrierDismissible : false,
          builder: (BuildContext context) {
            return CustomDialog(
              title: 'Updated Successfully!',
              message: ' ',
              buttonText: 'OK',
              onButtonPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        );

        Navigator.pop(context);
      });
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(    behavior: SnackBarBehavior.floating,
          content: Text(error.toString())));
      setState(() {
        _isSubmitting = false;
      });
    }
  }

// End of Form Submission
  ///---------------------  No Internet Dialog ----------------------------
  void _showNoInternetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  const Text('No Internet Connection'),
          content:  const Text('Please connect to a stable internet connection and try again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:  const Text('OK'),
            ),
          ],
        );
      },
    );
  }
  /// ---------------------- End No Internet Dialog -------------------------

  Future pickDateTimeStart() async {
    DateTime? dateStart = await pickDate();
    if (dateStart == null) return; // Cancel button.
    TimeOfDay? timeStart = await pickTimeStart();
    if (timeStart == null) return;

    final dateTimeStart = DateTime(
      dateStart.year,
      dateStart.month,
      dateStart.day,
      timeStart.hour,
      timeStart.minute,
    );

    setState(() {
      _dateTimeStart = dateTimeStart;
      startDate = '${dateTimeStart.year}/${dateTimeStart.month}/${dateTimeStart.day}';
      startTime = '${dateTimeStart.hour.toString().padLeft(2, '0')}:${dateTimeStart.minute.toString().padLeft(2, '0')}';
    });
  }

  Future pickDateTimeEnd() async {
    DateTime? dateEnd = await pickDate();
    if (dateEnd == null) return; // Cancel button.
    TimeOfDay? timeEnd = await pickTimeEnd();
    if (timeEnd == null) return;

    final dateTimeEnd = DateTime(
      dateEnd.year,
      dateEnd.month,
      dateEnd.day,
      timeEnd.hour,
      timeEnd.minute,
    );

    setState(() {
      _dateTimeEnd = dateTimeEnd;
      endDate = '${dateTimeEnd.year}/${dateTimeEnd.month}/${dateTimeEnd.day}';
      endTime = '${dateTimeEnd.hour.toString().padLeft(2, '0')}:${dateTimeEnd.minute.toString().padLeft(2, '0')}';
    });
  }

  Future<DateTime?> pickDate() async {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2060),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor:  Colors.blue[900], // Change this to the desired teal color
            hintColor:  Colors.blue[900], // Change this to the desired teal color
            colorScheme:  ColorScheme.light(primary: Colors.blue[900]!), // Change this to the desired teal color
            buttonTheme:  const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
  }

  Future<TimeOfDay?> pickTime() async {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor:  Colors.blue[900], // Change this to the desired teal color
            hintColor:  Colors.blue[900], // Change this to the desired teal color for time picker
            colorScheme:  ColorScheme.light(primary: Colors.blue[900]!), // Change this to the desired teal color
            buttonTheme:  const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
  }

  Future<TimeOfDay?> pickTimeStart() async {
    return pickTime();
  }

  Future<TimeOfDay?> pickTimeEnd() async {
    return pickTime();
  }


// Images URL

/*
  Future<TimeOfDay?> pickTime() async {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue[900], // Change this to the desired teal color
            hintColor: Colors.blue[900], // Change this to the desired teal color
            colorScheme: ColorScheme.light(primary: Colors.blue[900]), // Change this to the desired teal color
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
  }

  Future<TimeOfDay?> pickTimeStart() => showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: _dateTimeStart.hour, minute: _dateTimeStart.minute),
  );

  Future<TimeOfDay?> pickTimeEnd() => showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: _dateTimeEnd.hour, minute: _dateTimeEnd.minute),
  );
*/

}
