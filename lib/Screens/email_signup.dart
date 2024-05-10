import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:untitled/Screens/signup.dart';
import 'package:untitled/main.dart';
import 'PhotoContainerScreen.dart';
import 'adventures.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Initialize Firebase
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SignUpForm());
}

class SignUpForm extends StatelessWidget {
  const SignUpForm({Key? key}) : super(key: key);
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // primarySwatch: Color(0xFF700464),
      ),
      home:   const SignUpScreen(sourceScreen: '',),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  // this is to know from which screen is the customer coming
  final String sourceScreen;
  const SignUpScreen({Key? key, required this.sourceScreen}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}


class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _genderOptions = ['Male', 'Female'];
  String? _selectedGender;

  bool active = false;

  bool isLoading = false;

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  // ---------------------- To Firebase ----------------------

  Future<void> _signUp() async {

    setState(() {
     // isLoading = true;
    });
    // ----------- Validation ----------------------


    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      // Validate the required text fields

      try {
        // Register user with Firebase Authentication
        final UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text);

        // Increment the User count
        final doc = await FirebaseFirestore.instance.collection('user_count')
            .doc('count')
            .get();
        final count = doc.exists ? doc.data()!['count'] as int : 0;
        await FirebaseFirestore.instance.collection('user_count')
            .doc('count')
            .set({'count': count + 1});

        final String? token = await FirebaseMessaging.instance.getToken();


 //       final currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

        // Add the User data to Firestore with the UUID and count
        final userData = {

          'AccountCreationDate': DateTime.now(),
          'UserName' : _userNameController.text,
          'userID': userCredential.user!.uid,
          'User Count': count + 1,
          'User Email': _emailController.text,
          'User Gender': _selectedGender,
          'Phone Number': _phoneNumberController.text,
          'User Type' : 'Customer',
          'Platform':  Platform.operatingSystem,
           'Token' : token,
          'Member' : active,

          // 'User Location' : currentLocation,

        };
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(userData);

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(
                'You have registered your account successfully')));

        setState(() {
          isLoading = false;
        });

        Navigator.pushReplacement(
          context, MaterialPageRoute(
          builder: (context) => adventuresfunc(currentIndex: 0 ),
          ),
        );

      } catch (error) {
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())));
        setState(() {
          isLoading = false;
        });
      }

    }  else {
      setState(() {
      isLoading = false;
              });
           }
  }

  @override
    Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    final appBarColor = themeProvider.darkMode
        ? themeProvider.darkTheme.primaryColor
        : Color(0xFF700464);

      return Scaffold(
         backgroundColor:   const Color(0xFFeaeaea),
        resizeToAvoidBottomInset: false, // Add this line to disable animation
        appBar: AppBar(
          title: const Text('Sign Up', textAlign: TextAlign.center, style: TextStyle(color: Colors.white,) ),
          backgroundColor: appBarColor,
        ),
        body:  SingleChildScrollView(
         child: Container(

           /*
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/signUpScreenImage.png'),
                    fit: BoxFit.cover,
                  ),
                ),
            */
          child: Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'Wathbah',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    color: Color(0xFF700464),
                                  ),
                                ),
                              ),
                             // const SizedBox(height: 100.0),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                  controller: _userNameController,
                                  obscureText: false,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'User Name',
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 10),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your Username';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.white,
                                ),
                                child:
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Email',
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 10),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!value.contains('@')) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Container(
                                padding: const EdgeInsets.only(left: 16, right: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.white,
                                ),
                                child: DropdownButtonFormField<String>(

                                  value: _selectedGender,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedGender = newValue;
                                    });
                                  },

                                  items: _genderOptions
                                      .map((option) =>
                                      DropdownMenuItem(
                                        value: option,
                                        child: Text(option),
                                      ))
                                      .toList(),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Gender',
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 10),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select your gender';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Password',
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 10),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a password';
                                    }
                                    if (value.length < 6) {
                                      return 'Password must be at least 6 characters long';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                  controller: _phoneNumberController,
                                  keyboardType: TextInputType.phone,
                                  maxLength: 8,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Phone Number',

                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 10),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your phone number';
                                    }
                                    if (value.length != 8) {
                                      return 'Phone number must be 8 digits';
                                    }
                                    // Additional phone number validation if needed
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16.0),



                              Padding(
                                padding:  const EdgeInsets.fromLTRB(0, 20, 0, 5),
                                child:   ElevatedButton(

                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(9.0),
                                    ),
                                    backgroundColor: Color(0xFF700464),
                                    elevation: 5,
                                    minimumSize: const Size(double.infinity, 50),
                                  ),
                                  onPressed: isLoading ? null : _signUp,
                                  child: isLoading
                                      ? const CircularProgressIndicator(color: Colors.white,)
                                      : const Text("SIGN UP", style: TextStyle(color: Colors.white,)),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),


               /*

                    if (_isSubmitting)
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    if (_errorMessage != null)
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Center(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),

           */


                  ],
                ),
              ),

        )
      );
    }
  }



