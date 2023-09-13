import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/Screens/SplitScreensForm.dart';
import 'package:untitled/Screens/form_completed.dart';
import 'package:untitled/Screens/PhotoContainerScreen.dart';
import 'package:untitled/main.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'DisplayFullGoogleMaps.dart';
import 'package:uuid/uuid.dart';
/// Firebase Packages
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_datetime_picker/src/datetime_picker_theme.dart';

/// Initialize Firebase
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AdventureForm());
}

class AdventureForm extends StatelessWidget {
  const AdventureForm({Key? key}) : super(key: key);
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
       // primarySwatch: Colors.teal,
      ),
      home: const AdventureFormPage(),
    );
  }
}

class AdventureFormPage extends StatefulWidget {
  const AdventureFormPage({Key? key}) : super(key: key);
  @override
  _AdventureFormState createState() => _AdventureFormState();
}

class _AdventureFormState extends State<AdventureFormPage> {

  int _activeCurrentStep = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController advenproviderName = TextEditingController();
  TextEditingController adventureDescription = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController adventureTypeController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController maxNumController = TextEditingController();
  TextEditingController locationName = TextEditingController();
  TextEditingController LocationLink = TextEditingController();

  DateTime _dateTimeStart = DateTime.now();
  DateTime _dateTimeEnd = DateTime(2025, 1, 1, 00, 00);






  late  String   _StartDate = _dateTimeStart != null
        ? '${_dateTimeStart.year}/${_dateTimeStart.month}/${_dateTimeStart.day}'
        : "Not set";
  late  String    _EndDate = _dateTimeEnd != null
        ? '${_dateTimeEnd.year}/${_dateTimeEnd.month}/${_dateTimeEnd.day}'
        : "Not set";

  late String _StartTime = _dateTimeStart != null
      ? '${_dateTimeStart.hour.toString().padLeft(2, '0')}:${_dateTimeStart.minute.toString().padLeft(2, '0')}'
      : "Not set";

  late String _EndTime = _dateTimeEnd != null
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



  // Time and date picker
  late DateTime selectedDateTime;
  bool pressed = false;
  // form button
  bool isLoading = false;
  // gender buttons
  int _value = 0;
  int _AdvValue = 0;
  int _age = 0;
  int _diffLevel = 0;

  // Those variables to be printed/stored and sent to db
 // String provider_Name = "";
  String difficultyLevel = '';
  String easy = 'Easy';
  String moderate = 'Moderate';
  String challenging = 'Challenging';
  String onlyFamilies = '';
  String adventureNature = '';
  String gender = '';
  String age = '';
  late String Lat = '';
  late String Long = '';
  late String googleMapsLink = '';
  //late String locationName = '';

  bool isAdventureFree = false; // initialize the checkbox value
  String freeAdventure = '';

  final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter();

  final Color _textColor =  Colors.black;
  final Color _textColorWhite = Colors.white;


  @override
  void dispose() {
    adventureDescription.dispose();
    super.dispose();
  }

  /// ---------------- Validating the Text Fields ---------------------
  validateTextFields(String value) {
    setState(() {
      PhoneNumlength = value.length;
    });

    if (value.isEmpty) {
      return 'Please enter a username';
    }
    return null;

  }
  /// ---------------- Text Field Max length Alart Phone Number----------------------
  int PhoneNumlength = 0;
  _onChangedPhone(String value) {
    setState(() {
      PhoneNumlength = value.length;
    });

    if (PhoneNumlength == 8) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Opps '),
            content: const Text("You have reached the maximum digits for phone number"),
            actions: <Widget>[
              TextButton(
                // color: Colors.teal,
                child:  const Text("OK", textAlign: TextAlign.center, style:  TextStyle(color: Colors.white) ) ,
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
  /// ---------------- Text Field Max length Alart ----------------------
  int length = 0;
  _onChangedPrice(String value) {
    setState(() {
      length = value.length;
    });

    if (length == 16) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Opps '),
            content: const Text("You have reached the maximum price for the adventure"),
            actions: <Widget>[
              TextButton(
                //color: Colors.teal,
                child:  const Text("OK", textAlign: TextAlign.center, style:  TextStyle(color: Colors.white) ) ,
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
  int MaxNumPartici = 0;
  _onChangedMaxNum(String value) {
    setState(() {
      MaxNumPartici = value.length;
    });

    if (MaxNumPartici == 5) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Opps '),
            content: const Text("You have reached the maximum number of participants"),
            actions: <Widget>[
              TextButton(
                // color: Colors.teal,
                child:  const Text("OK", textAlign: TextAlign.center, style:  TextStyle(color: Colors.white) ) ,
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
    Step(
      state: _activeCurrentStep <= 0 ? StepState.editing : StepState.complete,
      isActive: _activeCurrentStep >= 0,
      title: const Text('Service Provider Details'),
      content: Column(
        children: [
         const SizedBox(height: 8,),
           Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: ListTile(
              leading: const Icon(Icons.person_rounded),
              title: TextField(
                keyboardType: TextInputType.name,
                controller: advenproviderName,
                decoration: const InputDecoration(
                  hintText:  "Adventure provider",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          //  Type of Adventure
          const Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: ListTile(
                leading: Icon(Icons.category),
                title: Text('Type of Adventure',
                    style: TextStyle(
                      fontSize: 15,
                    ))
            )
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: ListTile(
              title: DropdownButton(
                // Initial Value
                value: adventuresdropdown,
                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.teal, size: 30, ),
                isExpanded: true,
                // Array list of items
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items, textAlign: TextAlign.center),
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
          // Adventure Description
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: ListTile(
              leading: const Icon(Icons.description),
              title: TextField(
                controller: adventureDescription,
             //   onChanged: (AdventureDescrip) { AdventureDescription = AdventureDescrip;},
                keyboardType: TextInputType.multiline,

                minLines: 3, //Normal textInputField will be displayed
                maxLines: 20, // when user presses enter it will adapt to it
                decoration: const InputDecoration(
                  hintText: "Adventure Description",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          // Phone
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: ListTile(
              leading: const Icon(Icons.phone),
              title: TextField(
                keyboardType: TextInputType.phone,
                maxLength: 8,
                controller: phoneController,
                onChanged: (userPhone) {
                  if (_onChangedPhone == true) {
                    phoneController.text = userPhone;
                  }
                },
                decoration: const InputDecoration(
                  hintText: "Phone",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          // Difficulty
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
             child: ListTile(
               leading: Icon(Icons.accessibility),
              title: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                  Text("Difficulty level:"),
                 ]
             ),
               )
             ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
               //  const Text("Difficulty \nlevel:"),
                  //Easy
                  GestureDetector(
                   // onTap: () => setState(() => _diffLevel = 0),
                    onTap: () => setState(() {
                      _diffLevel = 0;
                      if (_diffLevel == 0) {
                      difficultyLevel = 'Easy';
                      print(difficultyLevel);
                      }
                    }),


                   child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 14,
                            offset: const Offset(4, 8),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.teal.withOpacity(0.2),
                          width: 1.0,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                        color: _diffLevel == 0 ? Colors.teal : Colors.transparent,
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
                        print(difficultyLevel);
                      }
                    }),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 14,
                            offset: const Offset(4, 8), // changes position of shadow
                          ),
                        ],
                        border: Border.all(
                          color: Colors.teal.withOpacity(0.2),
                          width: 1.0,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                        color:  _diffLevel == 1
                            ? Colors.teal
                            : Colors.transparent,
                      ),
                      height: 50,
                      width: 80,
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
                        print(difficultyLevel);
                      }
                    }),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 14,
                            offset: const Offset(4, 8), // changes position of shadow
                          ),
                        ],
                        border: Border.all(
                          color: Colors.teal.withOpacity(0.2),
                          width: 1.0,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                        color:  _diffLevel == 2 ? Colors.teal : Colors.transparent,
                      ),
                      height: 50,
                      width: 90,
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


    Step(
        state:
        _activeCurrentStep <= 1 ? StepState.editing : StepState.complete,
        isActive: _activeCurrentStep >= 1,

        title: const Text('Date and Time'),
        content: Column(
          children: [
            // Starts Date
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      elevation: 4.0,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)
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
                                    Text(' Start Date:  $_StartDate   '),
                                  Text(
                                    _StartTime,
                                    style: const TextStyle(
                                        color: Colors.white,
                                      //  fontWeight: FontWeight.bold,
                                        fontSize: 14.0),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const Text(
                            "  Change",
                            style: TextStyle(
                                color: Colors.white,
                               // fontWeight: FontWeight.bold,
                                fontSize: 12.0),
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
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      elevation: 4.0,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)
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
                                    Text('  End Date:    $_EndDate '),
                                  Text(
                                       '    $_EndTime',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const Text(
                            "  Change",
                            style: TextStyle(
                                color: Colors.white,
                               // fontWeight: FontWeight.bold,
                                fontSize: 12.0),
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
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
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
                                  const Icon(
                                    Icons.access_time,
                                    // size: 18.0,
                                    color: Colors.white,
                                  ),
                                  const Text('  Start Time:'),
                                  Text(
                                    "  $_StartTime",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const Text(
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
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
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
                                  const Icon(
                                    Icons.access_time,
                                    // size: 18.0,
                                    color: Colors.white,
                                  ),
                                  const Text('  End Time:'),
                                  Text(
                                    "  $_EndTime",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const Text(
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

    Step(
        state:
        _activeCurrentStep <= 1 ? StepState.editing : StepState.complete,
        isActive: _activeCurrentStep >= 2,

        title: const Text('Participants Details'),
        content: Column(
          children: [
            //-Only Families:
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Text( 'Only Families:',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold) ),
                  const Spacer(),
                  Switch(
                    activeColor: Colors.teal,
                    value: !_showTextField,
                    onChanged: (value) {
                       setState(() {
                         if (_showTextField = !_showTextField) {
                           onlyFamilies = 'No';
                           print(onlyFamilies);
                         } else  {
                           onlyFamilies = 'Only Families';
                           print(onlyFamilies);
                         }
                       });
                    },
                  ),
                ],
              ),
            ),
            // Adventure Nature
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Visibility(
                visible: _showTextField,
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('Adventure Nature:',
                        style: TextStyle(fontSize: 15, ), textAlign: TextAlign.left,
                      ),
                    ] ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0,  0),
                child: Visibility(
                  visible: _showTextField,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      GestureDetector(
                       // onTap: () => setState(() => _AdvValue = 0),
                        onTap: () => setState(() {
                          _AdvValue = 0;
                          if (_AdvValue == 0) {
                            adventureNature = 'Group Adventure';
                            print(adventureNature);
                          }
                        }),

                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 14,
                                offset: const Offset(4, 8),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.teal.withOpacity(0.2),
                              width: 1.0,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                            color: _AdvValue == 0 ? Colors.teal  : Colors.transparent,
                          ),
                          height: 80,
                          width: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:   <Widget>[
                              Icon(Icons.groups, size: 40,  color: _AdvValue == 0 ? _textColorWhite : _textColor), // icon
                              Text(
                                "Group Adventure",
                                style: TextStyle(fontWeight: FontWeight.bold,  fontSize: 12,  color: _AdvValue == 0 ? _textColorWhite : _textColor),
                              ), // text
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                      //  onTap: () => setState(() => _AdvValue = 1),
                        onTap: () => setState(() {
                          _AdvValue = 1;
                          if (_AdvValue == 1) {
                            adventureNature = 'Individual Adventure';
                            print(adventureNature);
                          }
                        }),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 14,
                                offset: const Offset(4, 8), // changes position of shadow
                              ),
                            ],
                            border: Border.all(
                              color: Colors.teal.withOpacity(0.2),
                              width: 1.0,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                            color: _AdvValue == 1
                                ? Colors.teal
                                : Colors.transparent,
                          ),
                          height: 80,
                          width: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:  <Widget>[
                              Icon(Icons.person, size: 40,  color: _AdvValue == 1 ? _textColorWhite : _textColor), // icon
                              Text(
                                "Individual Adventure", textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,  color: _AdvValue == 1 ? _textColorWhite : _textColor
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
            // Gender
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Visibility(
                  visible: _showTextField,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                          Text(  'Gender:',
                                        style: TextStyle(fontSize: 15, ), textAlign: TextAlign.left,
                                ),
                       ] ),
                ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
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
                          print(gender);
                        }
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 14,
                              offset: const Offset(4, 8),
                            ),
                          ],
                          border: Border.all(
                            color:  Colors.teal.withOpacity(0.2),
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                          color: _value == 0 ?  Colors.teal : Colors.transparent,
                        ),
                        height: 70,
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.female, size: 40, color: _value == 0 ? _textColorWhite : _textColor ), // icon
                            Text(
                              "Only Females",
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
                          print(gender);
                        }
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 14,
                              offset: const Offset(4, 8), // changes position of shadow
                            ),
                          ],
                          border: Border.all(
                            color: Colors.teal.withOpacity(0.2),
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                          color: _value == 1 ? Colors.teal : Colors.transparent,
                        ),
                        height: 70,
                        width: 85,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.male, size: 40, color: _value == 1 ? _textColorWhite : _textColor ), // icon
                            Text(
                              "Only Males",
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
                          gender = 'Both';
                          print(gender);
                        }
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 14,
                              offset: const Offset(4, 8), // changes position of shadow
                            ),
                          ],
                          border: Border.all(
                            color: Colors.teal.withOpacity(0.2),
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                          color: _value == 2
                              ? Colors.teal
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
                              "Both",
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
            // Age
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: ListTile(
                leading: const Text("Age:", style: TextStyle(fontSize: 15, ), textAlign: TextAlign.left,),
                title: Row(
                 // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                   // const Text("Age:", style: TextStyle(fontSize: 15, ), textAlign: TextAlign.left,),
                    const SizedBox(width: 35),
                    GestureDetector(
                   //   onTap: () => setState(() => _age = 0),
                      onTap: () => setState(() {
                        _age = 0;
                        if (_age == 0) {
                          age = '+12';
                          print(age);
                        }
                      }),

                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 14,
                              offset: const Offset(4, 8),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.teal.withOpacity(0.2),
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                          color: _age == 0 ? Colors.teal  : Colors.transparent,
                        ),
                        height: 70,
                        width: 90,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "+12",
                              style: TextStyle(fontWeight: FontWeight.bold,  fontSize: 20, color: _age == 0 ? _textColorWhite : _textColor ),
                            ), // text
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                     // onTap: () => setState(() =>  _age = 1),
                      onTap: () => setState(() {
                        _age = 1;
                        if (_age == 1) {
                          age = '+18';
                          print(age);
                        }
                      }),

                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 14,
                              offset: const Offset(4, 8), // changes position of shadow
                            ),
                          ],
                          border: Border.all(
                            color: Colors.teal.withOpacity(0.2),
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                          color:  _age == 1
                              ? Colors.teal
                              : Colors.transparent,
                        ),
                        height: 70,
                        width: 90,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  <Widget>[
                            Text(
                              "+18",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: _age == 1 ? _textColorWhite : _textColor ),
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
   // ---------------------------------------------------------

    Step(
        state:
        _activeCurrentStep <= 1 ? StepState.editing : StepState.complete,
        isActive: _activeCurrentStep >= 3,

        title: const Text('Price & Location'),
        content: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Text( 'Free Adventure:',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold) ),
                  const Spacer(),
                  Switch(
                    activeColor: Colors.teal,
                    value: !_showTextFieldforFreeAdventure,
                    onChanged: (value) {
                      setState(() {
                        if (_showTextFieldforFreeAdventure = !_showTextFieldforFreeAdventure) {
                          freeAdventure = 'No';
                          print(freeAdventure);
                        } else  {
                          freeAdventure = "Free Adventure";
                          print(freeAdventure);
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            //Price
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Visibility(
                visible: _showTextFieldforFreeAdventure,
                child: ListTile(
                  leading: const Icon(Icons.monetization_on),
                  title:TextField(
                    inputFormatters: <TextInputFormatter>[CurrencyTextInputFormatter(
                        locale: 'en_US',
                        decimalDigits: 0,
                        symbol: 'OMR '
                    )],
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    controller: priceController,
                    onChanged: (adventurePrice) {
                      if (_onChangedPrice == true) {
                        priceController.text = adventurePrice;
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: "Price",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Max Number of participants
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: ListTile(
                leading: const Icon(Icons.groups),
                title: TextField(
                  keyboardType: TextInputType.phone,
                  maxLength:4,
                  controller: maxNumController,
                  onChanged: (userMaxNum) {
                    if ( _onChangedMaxNum == true) {
                      maxNumController.text = userMaxNum;
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: "Max Number of participants",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            const Padding (
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: ListTile(
                leading: Icon(Icons.location_on,),
                title: Text('Gathering Point:'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: ListTile(
                leading: const Icon(Icons.location_on),
                title: TextField(
                  keyboardType: TextInputType.name,
                  controller: locationName,
                  decoration: const InputDecoration(
                    hintText:  "Location Name",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 15),
              child: ListTile(
                leading: const Icon(Icons.location_on),
                title: TextField(
                  keyboardType: TextInputType.name,
                  controller: LocationLink,
                  decoration: const InputDecoration(
                    hintText:  "Location Link",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),

           /*
            // Get the Map Link
            Padding (
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: ListTile(
                leading: const Icon(Icons.location_on,),
                title: const Text('Gathering Point:'),
                trailing:  ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.teal),
                  ),
                  child: const Text('Add a location '),
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

  //-----------------------------------------------------------
    Step(
        state: StepState.complete,
        isActive: _activeCurrentStep >= 4,
        title: const Text('Confirmation'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Step 1 Service Provider Details
            const Text('----------Service Provider Details-----------',style: TextStyle(fontWeight: FontWeight.bold,),),
            Text('Type of Adventure: ${advenproviderName.text}' ),
            Text('Type of Adventure: ${adventuresdropdown}' ),
             Text('Adventure Description: ${adventureDescription.text}'),
             Text('Phone Number: ${phoneController.text}'),
            Text('Level of Difficulty : ${difficultyLevel}'),

            const Text('-------------Date and Time--------------',style: TextStyle(fontWeight: FontWeight.bold,),),
            // Step 2 Date and Time
            Text('Start Date : ${_StartDate}'),
            Text('End Date: ${_EndDate}'),
            Text('Start Time: ${_StartTime}'),
            Text('End Time: ${_EndTime}'),

            const Text('-------------Participants Details--------------',style: TextStyle(fontWeight: FontWeight.bold,),),
            // Step 3 Participants Details
            Text('Is only family : ${onlyFamilies}'),
            Text('Adventure Nature : $adventureNature'),
            Text('Gender : $gender'),
            Text('Age : $age'),

            const Text('-------------Price & Location--------------',style: TextStyle(fontWeight: FontWeight.bold,),),
            // Step 4 Price & Location
            Text( "Is Free Adventure:  ${freeAdventure}"),
            Text('Price : ${priceController.text}'),
            Text('Max number of Participants : ${maxNumController.text}'),
          //  Text('Latitude : $Lat'),
          //  Text('Longitude : $Long'),
          //  Text('googleMapsLink : $googleMapsLink'),
           // Text('The name of the location : $locationName'),

            Text('googleMapsLink : ${LocationLink.text}'),
            Text('The name of the location : ${locationName.text}  '),

            SizedBox(height: 10,),

          ],
        ))

  ];



// The Actual Stepper

  @override
  Widget build(BuildContext context) {

    //time declaration does not go here

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: Text(
          'Adventure Form',
          style: GoogleFonts.satisfy(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [

        Theme(
         data: ThemeData(
           colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.teal, secondary: Colors.tealAccent),
         ),
          child: Stepper(
        type: StepperType.vertical,
         physics: const ScrollPhysics(),
        currentStep: _activeCurrentStep,
        steps: stepList(),



            controlsBuilder: (BuildContext context, ControlsDetails controlsDetails) {

              if (_activeCurrentStep == 0) {
                return Row(
                  children: <Widget>[
                    Spacer(),
                    ElevatedButton(
                      onPressed: controlsDetails.onStepContinue,
                      child: const Text('NEXT'),
                    ),
                    SizedBox(width: 8.0),
                  ],
                );
              } else if (_activeCurrentStep == stepList().length - 1) {
                return Row(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: controlsDetails.onStepCancel,
                      child: const Text('BACK'),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                      _submitForm();

                       Navigator.pop(context);

                      },


                      child: const Text('SUBMIT'),
                    ),
                    SizedBox(width: 8.0),
                  ],
                );
              } else {
                return Row(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: controlsDetails.onStepCancel,
                      child: const Text('BACK'),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: controlsDetails.onStepContinue,
                      child: const Text('NEXT'),
                    ),
                    SizedBox(width: 8.0),
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
             child: const Center(
          child: CircularProgressIndicator(),
        ),
      )
          : Container(),
      ],
    ),

    );
  }

// ---------------------- To Firebase ----------------------

  Future<void> _submitForm() async {
    setState(() {
      _isSubmitting = true;
          });


    // ----------- Validation ----------------------
    // Validate the required text fields
    if (advenproviderName.text == '' ||
        advenproviderName.text.isEmpty ||
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
        adventureNature.isEmpty

         ) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all required fields'),
            backgroundColor: Colors.red, // set the background color to red
          )
      );
      setState(() {
        _isSubmitting = false;
      });
      return;
    }
/*
    if (LocationLink == null || LocationLink == "" ) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
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
          const SnackBar(
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
    if (_StartDate == "Not set" || _EndDate == "Not set" || _StartTime == "Not set" || _EndTime == "Not set") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
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
    DateTime startTime = DateFormat('hh:mm a').parse(_StartTime);
    print(startTime);

    print('=============END TIME==================');
    DateTime endTime = DateFormat('hh:mm a').parse(_EndTime);
    print(endTime);

    print('=============Start DATE==================');
    DateTime startDate = DateFormat('dd-MM-yyyy').parse(_StartDate);
    print(startDate);

    print('=============END DATE==================');
    DateTime endDate = DateFormat('dd-MM-yyyy').parse(_EndDate);
    print(endDate);


    if (startTime.hour == endTime.hour && startTime.minute == endTime.minute) {
      print(startTime.hour);
      print('Yes Start Time = End Time');
      print(endTime.hour);
      print(startTime.minute);
      print('Yes Start Time = End Time');
      print(endTime.minute);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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
        const SnackBar(
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
          const SnackBar(
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
    print("I  am about  to submit this form ++++++++++++++++");
    try {
      // Generate a UUID
      final uuid = Uuid().v4();
      print("I am trying to submit this form ++++++++++++++++");
      // Increment the adventure count
      final doc = await FirebaseFirestore.instance.collection('adventure_count').doc('count').get();
      final count = doc.exists ? doc.data()!['count'] as int : 0;
      await FirebaseFirestore.instance.collection('adventure_count').doc('count').set({'count': count + 1});

      // Add the adventure data to Firestore with the UUID and count
      final adventureData = {

        'AdventureCreationDate': DateTime.now(),
        'AdventureID': uuid, // add the UUID to the map
        'AdventureNumber': count + 1,
        'ServiceProviderName': advenproviderName.text,
        'TypeOfAdventure': adventuresdropdown ,
        'AdventureDescription': adventureDescription.text,
        'PhoneNumber':phoneController.text,
        'LevelOfDifficulty' : difficultyLevel ,

        'StartDate' : _StartDate,
        'EndDate': _EndDate,
        'StartTime':  _StartTime,
        'EndTime':_EndTime,

        'IsOnlyFamily': onlyFamilies,
        'AdventureNature' :  adventureNature,
        'Gender' : gender ,
        'Age': age ,

        "IsFreeAdventure" : freeAdventure,
        'Price' : priceController.text,
        'MaxNumberOfParticipants' :  maxNumController.text,
       // 'Latitude ': Lat ,
       // 'Longitude ': Long ,
       // 'googleMapsLink ': googleMapsLink ,
        //'The name of the location ': locationName ,
        'googleMapsLink' : LocationLink.text,
        'TheNameOfTheLocation' : locationName.text,

      };
      await FirebaseFirestore.instance
          .collection('adventure')
          .add(adventureData);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Adventure submitted successfully')));
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

// End of Form Submission


  Future pickDateTimeStart() async {
    DateTime? _dateStart = await pickDate();
    if (_dateStart == null) return; // Cancel button.
    TimeOfDay? _timeStart = await pickTimeStart();
    if (_timeStart == null) return;

    final _dateTimeStart = DateTime(
      _dateStart.year,
      _dateStart.month,
      _dateStart.day,
      _timeStart.hour,
      _timeStart.minute,
    );

    setState(() {
      this._dateTimeStart = _dateTimeStart;
      _StartDate = '${_dateTimeStart.year}/${_dateTimeStart.month}/${_dateTimeStart.day}';
      _StartTime = '${_dateTimeStart.hour.toString().padLeft(2, '0')}:${_dateTimeStart.minute.toString().padLeft(2, '0')}';
    });
  }

  Future pickDateTimeEnd() async {
    DateTime? _dateEnd = await pickDate();
    if (_dateEnd == null) return; // Cancel button.
    TimeOfDay? _timeEnd = await pickTimeEnd();
    if (_timeEnd == null) return;

    final _dateTimeEnd = DateTime(
      _dateEnd.year,
      _dateEnd.month,
      _dateEnd.day,
      _timeEnd.hour,
      _timeEnd.minute,
    );

    setState(() {
      this._dateTimeEnd = _dateTimeEnd;
      _EndDate = '${_dateTimeEnd.year}/${_dateTimeEnd.month}/${_dateTimeEnd.day}';
      _EndTime = '${_dateTimeEnd.hour.toString().padLeft(2, '0')}:${_dateTimeEnd.minute.toString().padLeft(2, '0')}';
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
            primaryColor: Colors.teal, // Change this to the desired teal color
            hintColor: Colors.teal, // Change this to the desired teal color
            colorScheme: ColorScheme.light(primary: Colors.teal), // Change this to the desired teal color
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
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
            primaryColor: Colors.teal, // Change this to the desired teal color
            hintColor: Colors.teal, // Change this to the desired teal color for time picker
            colorScheme: ColorScheme.light(primary: Colors.teal), // Change this to the desired teal color
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
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

/*
  Future<TimeOfDay?> pickTime() async {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.teal, // Change this to the desired teal color
            hintColor: Colors.teal, // Change this to the desired teal color
            colorScheme: ColorScheme.light(primary: Colors.teal), // Change this to the desired teal color
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
