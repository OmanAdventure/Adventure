import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/Screens/signup.dart';
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
        // primarySwatch: Colors.teal,
      ),
      home:   SignUpScreen(sourceScreen: '',),
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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _genderOptions = ['Male', 'Female'];
  String? _selectedGender;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  // ---------------------- To Firebase ----------------------

   Future<void> _signUp(List<String> sourceScreens) async {
    setState(() {
  //    _isSubmitting = true;
    });
    // ----------- Validation ----------------------


    if (_formKey.currentState!.validate()) {
     setState(() {
        _isSubmitting = true;
      _errorMessage = null;
     });

      // Validate the required text fields


      try {
        // Generate a UUID
        final uuid = Uuid().v4();

        // Increment the User count
        final doc = await FirebaseFirestore.instance.collection('user_count')
            .doc('count')
            .get();
        final count = doc.exists ? doc.data()!['count'] as int : 0;
        await FirebaseFirestore.instance.collection('user_count')
            .doc('count')
            .set({'count': count + 1});

        // Add the User data to Firestore with the UUID and count
        final userData = {

          'AccountCreationDate': DateTime.now(),
          'UserID': uuid, // add the UUID to the map
          'User Count': count + 1,
          'User Email': _emailController.text,
          'User Gender': _selectedGender,
          'Password': _passwordController.text,
          'Phone Number': _phoneNumberController.text,

        };
        await FirebaseFirestore.instance
            .collection('users')
            .add(userData);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(
                'You have registered your account successfully')));

        setState(() {
          _isSubmitting = false;
        });


        if (sourceScreens.contains('AdventuresScreen')) {
          // Code for when the previous screen was Adventure.dart
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AdventuresContainerScreen(),
            ),
          );
        }

        if (sourceScreens.contains('HomeScreen')) {
          // Code for when the previous screen was HomeScreen

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => adventuresfunc(),
            ),
          );
        }


      } catch (error) {
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())));
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('iDiscover', textAlign: TextAlign.center),
          backgroundColor: Colors.teal,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/signUpScreenImage.png'),
                    fit: BoxFit.cover,
                  ),
                ),
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
                                        horizontal: 16.0, vertical: 10),
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
                              ElevatedButton(
                                onPressed: () {
                                  _signUp(['AdventuresScreen', 'HomeScreen']);
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.teal,
                                  padding: const EdgeInsets.fromLTRB(
                                      160, 16, 160, 16),
                                ),
                                child: const Text(' Sign Up '),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }



