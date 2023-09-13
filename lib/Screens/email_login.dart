import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:email_validator/email_validator.dart';
import '../main.dart';
import 'ForgetPassword.dart';
import 'PhotoContainerScreen.dart';
import 'email_signup.dart';
import 'package:provider/provider.dart';



class EmailLogIn extends StatefulWidget {
  @override
  _EmailLogInState createState() => _EmailLogInState();
}


class _EmailLogInState extends State<EmailLogIn> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void validate() {
    if (_formKey.currentState!.validate()) {
      print("Validated");
    } else {
      print("Not Validated");
    }
  }

  bool _validateEmail(String email) {
    if (email.isEmpty || !EmailValidator.validate(email)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Invalid Email"),
            content: Text("Please enter a valid email address."),
            actions: [
              ElevatedButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return false;
    }
    return true;
  }

  bool _validatePassword(String password) {
    if (password.isEmpty || password.length < 6) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Invalid Password"),
            content: Text("Password must be at least 7 characters."),
            actions: [
              ElevatedButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return false;
    }
    return true;
  }

  Future<void> _login() async {
    setState(() {
      isLoading = true;
    });

    final String email = emailController.text.trim();
    final String password = passwordController.text;

    try {
      // Validate email and password
      if (!_validateEmail(email) || !_validatePassword(password)) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Sign in user with Firebase Auth
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch user data from Firestore
      final userId = userCredential.user!.uid;
      final userData = await _fetchUserData(userId);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => adventuresfunc(),
        ),
      );

      print('User ID: $userId');
      print('User Data: $userData');
    } catch (error) {
      // Show error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(error.toString()),
            actions: [
              ElevatedButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    isLoading = false;
                  });
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<Map<String, dynamic>> _fetchUserData(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
    await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userSnapshot.data() ?? {};
  }




  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 10.0);
    TextStyle linkStyle = TextStyle(color: Colors.blue);

    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
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
                              color: Colors.teal,
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
                    Container(
                      color: Color(0xfff5f5f5),
                      child: TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'SFUIDisplay',
                        ),
                        decoration: const InputDecoration(
                          focusColor: Colors.teal,
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.teal,
                          ),
                          labelStyle: TextStyle(fontSize: 15),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Password';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters!';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding:  const EdgeInsets.fromLTRB(0, 20, 0, 5),
                          child:   ElevatedButton(

                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              backgroundColor: Colors.teal,
                                 elevation: 5,
                              minimumSize: Size(double.infinity, 50),
                            ),
                            onPressed: isLoading ? null : _login,
                            child: isLoading
                                ? const CircularProgressIndicator(color: Colors.white,)
                                : const Text("SIGN IN"),
                          ),

                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            //forgot password screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgetPassword(),
                              ),
                            );
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
                      ),
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 3),
                      child: Center(
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            fontFamily: 'SFUIDisplay',
                            color: Colors.teal,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUpScreen(
                                    sourceScreen: '',
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontFamily: 'SFUIDisplay',
                                color: Colors.teal,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100,),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 12, color: Colors.black ),

                            children: <TextSpan>[
                              const TextSpan(
                                text: 'By clicking Sign Up, you agree to our ',
                              ),
                              TextSpan(
                                text: 'Terms of Service',
                                style: linkStyle,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print('Terms of Service');
                                  },
                              ),
                              const TextSpan(text: ' and that you have read our '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: linkStyle,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print('Privacy Policy');
                                  },
                              ),
                            ],
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

      },
    );

  }


  Future<void> logInToFb(BuildContext context, String email, String password) async {
    setState(() {
      isLoading = true;
    });

    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      final UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = userCredential.user!.uid;
      final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
      final userData = userSnapshot.data();

      // Implement further logic with the retrieved user data
      print('Logged in successfully!');
      // Navigate to Home screen
      Navigator.of(context).pushReplacementNamed('/adventuresfunc');
      print('User ID: $userId');
      print('User Data: $userData');
    } catch (error) {
      print('Login failed: $error');
      // Handle login failure, e.g., show an error message to the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(error.toString()),
            actions: [
              ElevatedButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    isLoading = false;
                  });
                },
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }



/*
  _validateEmail(String email) {

    // Use a regular expression to validate email format
    // You can use a more sophisticated regex for email validation
    RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

    if (emailController.text == null || emailController.text.isEmpty) {
      print("Not Validated - Enter Email Address");
      showDialog(
        context: context,
        builder: (BuildContext context) => _emailDialogBuilder(context),
      );
    } else if (!EmailValidator.validate(emailController.text)) {
      print("Not Validated - Please enter a valid email address!");
      showDialog(
        context: context,
        builder: (BuildContext context) => _emailDialogBuilder(context),
      );
    } else if (!emailRegex.hasMatch(emailController.text))  {
      showDialog(
        context: context,
        builder: (BuildContext context) => _emailDialogBuilder(context),
      );
    } else {
      print('Validated');
    }
  }

  _validatePassword(String password) {
    if (passwordController.text.isEmpty ||
        passwordController.text == null ||
        passwordController.text.length < 7) {
      print("Not Validated");
      showDialog(
        context: context,
        builder: (BuildContext context) => _passwordDialogBuilder(context),
      );
    } else {
      print("Validated");
    }
  }
*/
  static Widget _emailDialogBuilder(BuildContext context) {
    return AlertDialog(
      scrollable: true,
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
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
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
    );
  }

  static Widget _passwordDialogBuilder(BuildContext context) {
    return AlertDialog(
      scrollable: true,
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
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
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
    );
  }
}
