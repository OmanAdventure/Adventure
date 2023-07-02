import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Screens/PhotoContainerScreen.dart';
import 'PhotoContainerScreen.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_button/sign_button.dart';


//import 'home.dart';

class EmailSignUp extends StatefulWidget {
  @override
  _EmailSignUpState createState() => _EmailSignUpState();
}

class _EmailSignUpState extends State<EmailSignUp> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child("Users");
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  // TextEditingController genderController = TextEditingController();

  // Initial Selected Value
  String genderDropdown = 'Male';
  // List of items in our dropdown menu
  var genderList = [
    'Male',
    'Female',
  ];

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/signUpScreenImage.png'),
            // Try This too --> assets/images/LoginImage.png
            fit: BoxFit.cover,
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.all(23),
            child: ListView(
              children: <Widget>[
                const SizedBox(height: 30,),
                Form(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:  const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: TextFormField(
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white
                                  )
                              ),
                              labelText: 'Email',
                              labelStyle: TextStyle(fontSize: 15,
                                  color: Colors.white)
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      DecoratedBox(
                          decoration: BoxDecoration(
                              color:Color(0xFFE0E0E0), //background color of dropdown button
                              border: Border.all(color: Colors.transparent, width:3), //border of dropdown button
                              borderRadius: BorderRadius.circular(20), //border raiuds of dropdown button
                              boxShadow: const <BoxShadow>[ //apply shadow on Dropdown button
                                BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.02), //shadow for button
                                    blurRadius: 5) //blur radius of shadow
                              ]
                          ),

                          child:Padding(
                              padding: const EdgeInsets.only(left:20, right:20),
                              child:DropdownButton(
                                value: genderDropdown,
                                focusColor: Colors.white,
                                items: genderList.map((String genderList) {
                                  return DropdownMenuItem(
                                    value: genderList,
                                    child: Text(genderList, textAlign: TextAlign.center),
                                  );
                                }).toList(),

                                onChanged: (String? newValue) {
                                  setState(() {
                                    genderDropdown = newValue!;
                                  });
                                },
                                icon: const Padding( //Icon at tail, arrow bottom is default icon
                                    padding: EdgeInsets.only(left:20),
                                    child:Icon(Icons.arrow_circle_down_sharp, color: Colors.teal,)
                                ),
                                iconEnabledColor: Colors.white, //Icon color
                                style: const TextStyle(  //te
                                    color: Colors.black, //Font color
                                    fontSize: 15 //font size on dropdown button
                                ),
                                dropdownColor: Colors.white, //dropdown background color
                                underline: Container(), //remove underline
                                isExpanded: true, //make true to make width 100%
                              )
                          )
                      ),

                      TextFormField(
                        obscureText: true,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white
                                )
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(fontSize: 15,
                                color: Colors.white)
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:  const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: TextFormField(
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white
                            )
                        ),
                        labelText: 'Phone',
                        labelStyle: TextStyle(fontSize: 15,
                            color: Colors.white)
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: MaterialButton(
                    onPressed: (){},
                    color: Colors.teal,
                    elevation: 0,
                    minWidth: 350,
                    height: 60,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                    ),
                    child:  const Text('SIGN UP',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'SFUIDisplay',
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: MaterialButton(
                    onPressed: (){},
                    color:Color(0xFFE0E0E0),
                    elevation: 0,
                    minWidth: 350,
                    height: 60,
                    textColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(color: Colors.transparent)
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(Icons.account_circle_sharp),
                        Text('Sign up with Google',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'SFUIDisplay'
                          ),)
                      ],
                    ),
                  ),
                ),


                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(
                                text: "Don't have an account?",
                                style: TextStyle(
                                  fontFamily: 'SFUIDisplay',
                                  color: Colors.white,
                                  fontSize: 15,
                                )
                            ),
                            TextSpan(
                                text: "sign up",
                                style: TextStyle(
                                  fontFamily: 'SFUIDisplay',
                                  color: Color(0xffff2d55),
                                  fontSize: 15,
                                )
                            )
                          ]
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void registerToFb() {
    firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((result) {
      dbRef.child(result.user!.uid).set({
        "email": emailController.text,
        "age": ageController.text,
        "name": nameController.text
      }).then((res) {
        isLoading = false;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => adventuresfunc(uid: result.user!.uid)),
        );
      });
    }).catchError((err) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(err.message),
              actions: [
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    ageController.dispose();
  }
}
