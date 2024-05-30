import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                      Text('Hello', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                      Text('Welcome!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,
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
              // Password
                SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration:   InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: const Icon(Icons.visibility_off),
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius:  BorderRadius.circular(40.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              //Forgot password?
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child:   Text('Forgot password?', style: TextStyle(color: Colors.blue[900],),),
                ),
              ),
              const SizedBox(height: 12),
              // Sign In button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isChecked ? () {} : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text('Sign In' , style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
           // Terms & Conditions
               Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: [
                           Checkbox(
                             value: _isChecked,
                             hoverColor: Colors.blue[900],
                             activeColor: Colors.blue[900],
                             onChanged: (bool? value) {
                               setState(() {
                                 _isChecked = value?? false;
                               });
                             },
                           ),
                           const Text('I agree with ', style: TextStyle(color: Colors.grey)),
                          GestureDetector(
                           onTap: () {
                            if (kDebugMode) {
                              print("object");
                             }
                           },
                           child: Text('Terms & Conditions', style: TextStyle(color: Colors.blue[900])),
                           )
                         ],
                      ),
            // Don’t have an account?
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 150, 20, 10),
               child:  GestureDetector(
                onTap: () {}, // Navigate to sign up
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don’t have an account?', style: TextStyle(color: Colors.grey)),
                       const SizedBox(width: 30,),
                      Text('Sign up', style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold)),
                    ],
                  )

                ),
              ),

              ),

            ],
          ),
        ),
      ),
    );
  }
}
