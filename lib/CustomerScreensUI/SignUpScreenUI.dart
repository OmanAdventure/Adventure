import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _gender = 'Select Gender';
  bool _isAgreed = false;

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.ac_unit, size: 80, color: Colors.blue[900]), // Placeholder for logo
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hello        ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('Create an account', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Full Name
              SizedBox(
            height: 55,
            width: double.infinity,
            child:  TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
              ),
            ),
          ),
              const SizedBox(height: 12),
              // Email
              SizedBox(
                height: 55,
                width: double.infinity,
              child:  TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
                ),
              ),
              ),
              const SizedBox(height: 12),
              // Gender
              SizedBox(
                height: 55,
                width: double.infinity,
                child: DropdownButtonFormField<String>(
                  value: _gender == 'Select Gender' ? null : _gender,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
                    prefixIcon: Icon(Icons.people_alt_sharp),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),  // Adjust padding to fit the height
                  ),
                  items: <String>['Male', 'Female'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(fontSize: 16)),  // Set the text size in the dropdown items
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _gender = value!;
                    });
                  },
                  hint: Text(_gender, style: TextStyle(fontSize: 20)),  // Set the hint text size
                  style: TextStyle(fontSize: 20, color: Colors.black),  // Default text style inside the dropdown
                  dropdownColor: Colors.white,  // Optional: Changes the background color of the dropdown
                  borderRadius: BorderRadius.circular(40),  // Set the borderRadius for the dropdown menu
                ),
              ),

              const SizedBox(height: 7),
              // Password
              SizedBox(
                height: 55,
                width: double.infinity,
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: Icon(Icons.visibility_off),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                width: double.infinity,
                child: TextField(
                  keyboardType: TextInputType.phone,
                  maxLength: 8,
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
                  ),
                ),
              ),

            //  const SizedBox(height: 12),


              Row(
                children: [
                  Checkbox(
                    value: _isAgreed,
                    onChanged: (bool? value) {
                      setState(() {
                        _isAgreed = value!;
                      });
                    },
                    activeColor: Colors.blue[900],
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isAgreed ? () {} : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),

              // Already have an account?
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child:  GestureDetector(
                  onTap: () {}, // Navigate to sign up
                  child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account?', style: TextStyle(color: Colors.grey)),
                          const SizedBox(width: 30,),
                          Text('Sign in', style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold)),
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
