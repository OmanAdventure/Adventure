import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_carousel_widget/flutter_carousel_indicators.dart';
import 'PhotoContainerScreen.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'home.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:email_validator/email_validator.dart';
import 'email_signup.dart';

class EmailLogIn extends StatefulWidget {
  @override
  _EmailLogInState createState() => _EmailLogInState();
}

class _EmailLogInState extends State<EmailLogIn> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void validate() {
    if(_formKey.currentState!.validate()){
      print("validates");
    } else{
      print(" not validates");
    }
  }

  void EmailValidator() {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(emailController.text);
  }
}

// Email validator
  void emailValidator() {

    if(emailController.text == null || emailController.text.isEmpty ){
      print("Not validates - Enter Email Address");
      Navigator.of(context).restorablePush(_emailDialogBuilder);
    } else if (!emailController.text.contains('@')){
      print("Validates - Please enter a valid email address!");
      Navigator.of(context).restorablePush(_emailDialogBuilder);
    } else {
      print('Validated');
    }
  }


  // Password validator
  void passwordValidator() {

    if (passwordController.text.isEmpty || passwordController.text == null || passwordController.text.length < 7) {
      print("Not validates");
      Navigator.of(context).restorablePush(_passwordDialogBuilder);
    } else if (!(passwordController.text.contains('@')) || !(passwordController.text.contains('!')) ){
      print("Validates");
    }

  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 10.0);
    TextStyle linkStyle = TextStyle(color: Colors.blue);
    return Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration (
              image: DecorationImage(
                  image: AssetImage('assets/images/LoginImage.png'),
                  // https://www.oerlive.com/oman/4-unique-ideas-for-a-socially-distanced-holiday-adventure-in-oman/
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter
              )
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 225),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(23),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Container(
                    color: Color(0xfff5f5f5),
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'SFUIDisplay'
                      ),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email, color: Colors.teal,),
                          labelStyle: TextStyle(
                              fontSize: 15
                          )
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Email Address';
                        } else if (!value.contains('@')) {
                          return 'Please enter a valid email address!';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Container(
                  color: Color(0xfff5f5f5),
                  child: TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'SFUIDisplay'
                    ),
                    decoration: const InputDecoration(
                      focusColor: Colors.teal,
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock, color: Colors.teal,),
                        labelStyle: TextStyle(
                            fontSize: 15
                        )
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty || emailController.text == null || emailController.text.isEmpty ) {
                        return 'Enter Password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters!';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: isLoading
                          ? Container(
                            height: 60.0,
                            child: const Center(
                                child:   CircularProgressIndicator(
                              valueColor:  AlwaysStoppedAnimation<Color>(Colors.teal),
                               strokeWidth: 5.0,
                            )),
                            )
                      : MaterialButton(
                         onPressed: (){

                           emailValidator();
                           passwordValidator();


                           if (emailController.text.isEmpty == true || passwordController.text.isEmpty == true) {
                             setState(() {
                               isLoading = false;
                             });
                           } else if (emailController.text.isEmpty == false || passwordController.text.isEmpty == false) {
                           setState(() {
                             isLoading = true;
                           });
                           logInToFb();
                           }

                           print(emailController.text);
                           print(emailController.text);

                           /*
                          if (_formKey.currentState!.validate()) {
                          setState(() {
                          isLoading = true;
                          });
                          logInToFb();
                          }
                        */

                                  },
                            color: Colors.teal,
                            elevation: 0,
                            minWidth: 400,
                            height: 50,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),//since this is only a UI app

                         child: const Text('SIGN IN',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'SFUIDisplay',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding:  EdgeInsets.only(top: 5),
                    child: Center(
                      child: TextButton(
                            onPressed: () {
                              //forgot password screen
                            },
                            child: const Text(
                              'Forgot Password ?',
                              style: TextStyle(
                                fontFamily: 'SFUIDisplay',
                                color: Colors.teal,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                    )
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Center(
                    child: RichText(
                      text: const TextSpan(
                          children: [
                            TextSpan(
                                text: "Don't have an account with Oman Adventure? ",
                                style: TextStyle(
                                  fontFamily: 'SFUIDisplay',
                                  color: Colors.black,
                                  fontSize: 15,
                                )
                            ),
                          ]
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding:  EdgeInsets.only(top: 3),
                  child: Center(

                      child: DefaultTextStyle(
                          style: const TextStyle(
                            fontFamily: 'SFUIDisplay',
                            color: Colors.teal,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        child: TextButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EmailSignUp()),
                            );
                          },
                           child: const Text('Sign Up',
                             style: TextStyle(
                             fontFamily: 'SFUIDisplay',
                             color: Colors.teal,
                             fontSize: 15,
                             fontWeight: FontWeight.bold,
                           ),
                           ),
                        ),
                      )

                  )
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        style: defaultStyle,
                        children: <TextSpan>[
                          const TextSpan(text: 'By clicking Sign Up, you agree to our '),
                          TextSpan(
                              text: 'Terms of Service',
                              style: linkStyle,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print('Terms of Service"');
                                }),
                          const TextSpan(text: ' and that you have read our '),
                          TextSpan(
                              text: 'Privacy Policy',
                              style: linkStyle,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print('Privacy Policy"');
                                }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  } // Widget Builder

  void logInToFb() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((result) {
      isLoading = false;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => adventuresfunc(uid: result.user!.uid)),
      );
    }).catchError((err) {
      print(err.message);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.message),
              actions: [
                ElevatedButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }


  // ------Email Dialog Builder-----

  /// Dialog Builder
  static Route<Object?> _emailDialogBuilder(
      BuildContext context, Object? arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        scrollable: true, // <-- Set it to true
        content: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.warning, color: Colors.teal),
                  label: const Text(
                    "Please make sure to enter a valid email address",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      color: Colors.teal,
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child:  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"),
                  ),

            ),
          ],
        ),
      ),
    );
  }

//------Password Dialog Builder-----

  /// Dialog Builder
  static Route<Object?> _passwordDialogBuilder(
      BuildContext context, Object? arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        scrollable: true, // <-- Set it to true
        content: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.warning, color: Colors.teal),
                  label: const Text(
                    "Please make sure to enter a password with at least 7 characters mixed with numbers, letters and \n at least one special character, e.g., ! @ # ? ] ",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      color: Colors.teal,
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child:  ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),

            ),
          ],
        ),
      ),
    );
  }

//--------------------
} // State


