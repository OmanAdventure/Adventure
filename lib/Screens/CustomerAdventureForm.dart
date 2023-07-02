import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/Screens/form_completed.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart'
//import 'package:flutter_datetime_picker/src/datetime_picker_theme.dart' as DateTimePicker;


// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() => MyCustomFormState();
}

// Define a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  void validate() {
    if (_formKey.currentState!.validate()) {
      print("validates");
    } else {
      print(" not validates");
    }
  }

  /// Which holds the selected date
  /// Defaults to today's date.
  DateTime selectedDate = DateTime.now();
  // Time and date picker
  late DateTime selectedDateTime;
  bool pressed = false;
  // form button
  bool isLoading = false;

  // gender buttons
  int _value = 0;

  String _date = "Not set";
  String _time = "Not set";

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Name
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: ListTile(
                leading: Icon(Icons.person),
                title: TextField(
                  decoration: InputDecoration(
                    hintText: "Name",
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
            const Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
             child: ListTile(
                leading: Icon(Icons.phone),
                title: TextField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
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
            // Email
            const Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child:  ListTile(
                leading: Icon(Icons.email),
                title: TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Email",
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

             Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
             child: ListTile(
               leading: Icon(Icons.today),
               title: const Text(
                 'Choose a Date :',
                 style: TextStyle(
                   color: Colors.black,
                   fontSize: 16,
                 ),
               ),
               trailing:  ElevatedButton(
                 style:  ButtonStyle(
                     backgroundColor:
                     MaterialStateProperty.all<Color>(Colors.teal)
                 ),
                 onPressed: () {

                 },
                 child:  Text(
                   "${selectedDate .toLocal()}".split(' ')[1],
                   style: const TextStyle(
                       fontSize: 16,
                       color: Colors.white,
                       fontWeight: FontWeight.bold),
                 ),
               )
             )
            ),
// -----------------------------------

            //---------------------------


            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => setState(() => _value = 0),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 14,
                            offset: Offset(4, 8),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.teal.withOpacity(0.2),
                          width: 1.0,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                        color: _value == 0 ? Colors.pink : Colors.transparent,
                      ),
                      height: 80,
                      width: 120,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Icon(Icons.female, size: 40), // icon
                          Text(
                            "Female",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ), // text
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => setState(() => _value = 1),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 14,
                            offset: Offset(4, 8), // changes position of shadow
                          ),
                        ],
                        border: Border.all(
                          color: Colors.teal.withOpacity(0.2),
                          width: 1.0,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                        color: _value == 1
                            ? Colors.blueAccent
                            : Colors.transparent,
                      ),
                      height: 80,
                      width: 120,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Icon(Icons.male, size: 40), // icon
                          Text(
                            "Male",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ), // text
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 30),
              child: isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      style: ButtonStyle(
                          textStyle: MaterialStateProperty.all<TextStyle>(
                              TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                          minimumSize:
                              MaterialStateProperty.all<Size>(Size(400, 50)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.teal)),
                      onPressed: () {

           //   Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => FormCompleted()));

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context ) => FormCompleted()),
                        );

                      /*
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;

                          });
                          // registerToFb();
                        }
                    */
                      },
                      child: const Text('Submit'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
/*
// Time date picker
Widget _displayDateTime(selectedDateTime) {
  return Center(
      child: Text(
    "Selected  $selectedDateTime",
    style: TextStyle(fontSize: 15),
  ));
}
*/


// picker customization
/*
class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({required DateTime currentTime, required LocaleType locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }
/*
  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex())
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex());
  }
  */
}
*/
