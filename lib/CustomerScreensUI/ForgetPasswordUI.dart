import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:untitled/components/CustomAlertUI.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return   const MaterialApp(
      home: ForgetPasswordScreen(),
    );
  }
}

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});



  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(' ', style: TextStyle(color: Colors.black)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.ac_unit, size: 80, color: Colors.blue[900]), // Placeholder for logo
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Reset', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                      Text('Password!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 60),
              // Username
              SizedBox(
                height: 55,
                width: double.infinity,
                child: TextField(
                  controller: emailController,
                  decoration:   InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius:  BorderRadius.circular(40.0),
                    ),
                    prefixIcon: const Icon(Icons.email),
                  ),
                ),
              ),
              const SizedBox(height: 12),


              const SizedBox(height: 12),
              // Sign In button
              SizedBox(
                width: double.infinity,

               child:  ElevatedButton(
                 style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.blue[900],
                   padding: const EdgeInsets.symmetric(vertical: 16.0),
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(30.0),
                   ),
                 ),
                 child: const Text('Reset Password' , style: TextStyle(color: Colors.white)),
                 onPressed: () {
                   showDialog(
                     context: context,
                     barrierDismissible : false,
                     builder: (BuildContext context) {
                       return CustomDialog(
                         title: 'Password Reset',
                         message: 'Your password reset link has been sent. Please check your email ',
                         buttonText: 'OK',
                         onButtonPressed: () {
                           Navigator.of(context).pop();
                         },
                       );
                     },
                   );
                 },
               ),

            ),


              const SizedBox(height: 40),

              // Don’t have an account?
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      GestureDetector(
                        onTap: () { print("Sign In");}, // Navigate to sign up
                        child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Already have an account?', style: TextStyle(color: Colors.grey)),
                                const SizedBox(width: 30,),
                                Text('Sign In', style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold)),
                              ],
                            )
                        ),
                      ),

                    const SizedBox(height: 30,),
                    /*
                    GestureDetector(
                      onTap: () { print("Sign up");},

                     child:  Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don’t have an account?', style: TextStyle(color: Colors.grey)),
                            const SizedBox(width: 30,),
                            Text('Sign up', style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold)),
                          ],
                        )

                    ),
                    )
                    */
                  ],
                ),
              ),



            ],
          ),
        ),
      ),
    );
  }
}
