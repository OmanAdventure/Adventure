import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:email_validator/email_validator.dart';
import 'PhotoContainerScreen.dart';
import 'email_login.dart';
import 'email_signup.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  bool _isLoading = false;

  // Function to send a password reset email
  void sendPasswordResetEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Check if the user email exists in the "users" collection in Firebase
        final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: emailController.text.trim())
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Email exists in the "users" collection, send password reset email
          await FirebaseAuth.instance.sendPasswordResetEmail(
            email: emailController.text.trim(),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password reset email sent successfully!'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          // Email does not exist in the "users" collection, show alert
          showDialog(
            context: context,
            builder: (BuildContext context) => _emailDialogBuilder(context),
          );
        }

        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send password reset email.'),
            duration: Duration(seconds: 2),
          ),
        );

        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void validate() {
    if (_formKey.currentState!.validate()) {
      print("Validated");
    } else {
      print("Not Validated");
    }
  }

  void emailValidator() {
    if (emailController.text == null || emailController.text.isEmpty) {
      print("Not Validated - Enter Email Address");
    } else if (!EmailValidator.validate(emailController.text)) {
      print("Not Validated - Please enter a valid email address!");
    } else {
      print('Validated');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 10.0);
    TextStyle linkStyle = TextStyle(color: Colors.blue);
    return Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/LoginImage.png'),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
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
                        fontFamily: 'SFUIDisplay',
                      ),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        prefixIcon: Icon(
                          Icons.email,
                          color: Color(0xFF700464),
                        ),
                        labelStyle: TextStyle(fontSize: 15),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Email Address';
                        } else if (!EmailValidator.validate(value)) {
                          return 'Please enter a valid email address!';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: _isLoading
                      ? Container(
                    height: 60.0,
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF700464)),
                        strokeWidth: 5.0,
                      ),
                    ),
                  )
                      : MaterialButton(
                    onPressed: () async {
                      emailValidator();

                      if (emailController.text.isEmpty) {
                        setState(() {
                          _isLoading = false;
                        });
                      } else {
                        // Call the function to send password reset email
                        sendPasswordResetEmail();
                      }
                    },
                    color: Color(0xFF700464),
                    elevation: 0,
                    minWidth: 400,
                    height: 50,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Reset my Password',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'SFUIDisplay',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        //forgot password screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmailLogIn(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign In?',
                        style: TextStyle(
                          fontFamily: 'SFUIDisplay',
                          color: Color(0xFF700464),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Widget _emailDialogBuilder(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton.icon(
              onPressed: null,
              icon: const Icon(Icons.warning, color: Color(0xFF700464)),
              label: const Text(
                "Please make sure to enter a valid email address",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: Color(0xFF700464),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF700464),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ),
        ],
      ),
    );
  }
}
