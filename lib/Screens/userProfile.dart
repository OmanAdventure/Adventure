import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:provider/provider.dart';

import 'package:untitled/l10n/messages_all.dart';
import 'package:untitled/l10n/messages_all_locales.dart';
import 'package:untitled/l10n/messages_en.dart'; // For English
import 'package:untitled/l10n/messages_ar.dart'; // For Arabic




class UserModelProfile {
  final String userName;
  final String id;
  final String email;
  final String phoneNumber;
  final String gender;

  UserModelProfile({
    required this.userName,
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.gender,
  });

}

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {

  late Future<UserModelProfile> _userDataFuture;
  late UserModelProfile _user;




  @override
  void initState() {
    super.initState();
    _user = UserModelProfile(
      userName: "",
      id: "",
      email: "",
      phoneNumber: "",
      gender: "",
    );

    _userDataFuture = _getUserData();
  }

  Future<UserModelProfile> _getUserData() async {

    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(user.uid).get();

        return UserModelProfile(

          userName: userSnapshot.data()?["UserName"] ?? "",
          id: user.uid,
          email: user.email ?? "",
          phoneNumber: userSnapshot.data()?["Phone Number"] ?? "",
          gender: userSnapshot.data()?["User Gender"] ?? "",

        );
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return _user;
  }

  Future<void> _editPhoneNumber() async {
    // Show the dialog to get the new phone number
    String? newPhoneNumber = await _showEditPhoneNumberDialog();

    // Check conditions before updating the phone number
    if (newPhoneNumber != null && newPhoneNumber.length == 8) {
      try {
        // Update the phone number in Firebase
        await _updatePhoneNumber(newPhoneNumber);
      } catch (e) {
        print("Error updating phone number: $e");
      }
    } else {
      // Show an alert for invalid phone number
      showPhoneNumberAlert();
    }
  }

  Future<String?> _showEditPhoneNumberDialog() async {
    TextEditingController phoneNumberController = TextEditingController();

    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Phone Number"),
        content: TextField(
          controller: phoneNumberController,
          decoration: const InputDecoration(labelText: "New Phone Number" ),
          keyboardType: TextInputType.phone,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Cancel button
            child: const Text("Cancel" , style: TextStyle(color: Color(0xFF700464))),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(phoneNumberController.text); // Save button
            },
            child: const Text("Save" , style: TextStyle(color: Color(0xFF700464))),
          ),
        ],
      ),
    );
  }

  Future<void> _updatePhoneNumber(String newPhoneNumber) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userID = user.uid;
      print('Current User ID: $userID');

      try {
        // Update the phone number in Firestore
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userID)
            .update({"Phone Number": newPhoneNumber});

        // Fetch and update the displayed user data
        setState(() {
          _userDataFuture =  _getUserData();
          //_fetchUserData(userID);
        });

        print("Phone Number updated successfully");
      } catch (e) {
        print("Error updating phone number: $e");
      }
    } else {
      print('No user is currently logged in.');
    }
  }


  void showPhoneNumberAlert() {
    // You can use your own alert dialog implementation here
    // For simplicity, I'm using the basic `showDialog` in this example
    showDialog(
      context: context, // Make sure you have access to the context
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Invalid Phone Number"),
          content: const Text("Please enter a valid 8-digit phone number."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert dialog
              },
              child: const Text("OK" , style: TextStyle(color: Color(0xFF700464))),
            ),
          ],
        );
      },
    );
  }


  // To fetch data once the phone number is updated
  Future<UserModelProfile> _fetchUserData(String userID) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await FirebaseFirestore.instance.collection("users").doc(userID).get();

      return UserModelProfile(
        userName: userSnapshot.data()?["UserName"] ?? "",
        id: userID,
        email: userSnapshot.data()?["User Email"] ?? "",
        phoneNumber: userSnapshot.data()?["Phone Number"] ?? "",
        gender: userSnapshot.data()?["User Gender"] ?? "",
      );
    } catch (e) {
      print("Error fetching user data: $e");
      throw e; // Rethrow the exception to propagate the error
    }
  }
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final appBarColor = themeProvider.darkMode
        ? themeProvider.darkTheme.primaryColor
        : const Color(0xFF700464);


    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile",  style: TextStyle(color: Colors.white),    ),
       // backgroundColor: Color(0xFF700464),
        backgroundColor: appBarColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF700464).withAlpha(100),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),

                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 0),
                  ],
                ),

            ),
          //  const SizedBox(height: 20),

            FutureBuilder<UserModelProfile>(
              future: _userDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF700464), backgroundColor: Colors.white,));
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text("No user data available."));
                } else {
                  final UserModelProfile user = snapshot.data!;

                  return Container(
                    // for the text fields
                    padding:  const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFF484747)),
                    ),
                    child: Column(
                      children: <Widget>[

                        ClipOval(
                          child: Container(
                            color: const Color(0xFF700464),
                            width: 150, // Adjust the size of the circle as needed
                            height: 150,
                            child: Image.asset(
                              'assets/images/profileImage.png', // Replace with the path to your image asset
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        buildListTile("User Name", user.userName),
                        buildListTile("Email", user.email),
                        buildListTile("Phone Number", user.phoneNumber,
                          trailing:  IconButton(
                                icon: const Icon(Icons.edit, color: Color(0xFF700464)),
                                onPressed: _editPhoneNumber,
                              ),
                           ),
                        buildListTile("Gender", user.gender),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListTile(String title, String subtitle, {Widget? trailing}) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Text(
          title,
          style: const TextStyle(
            textBaseline: TextBaseline.alphabetic,
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: title,
            labelText: subtitle,
            enabled: false,
            hintStyle: const TextStyle(
              textBaseline: TextBaseline.alphabetic,
             color: Colors.grey,
              fontSize: 12,
            ),
              // Set the text color for the input field
            labelStyle: const TextStyle(
                color: Colors.black,
                fontSize: 16,

              ),
            // Set the contentPadding to adjust the height of the TextField
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0,
              horizontal: 8.0,),
          ),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
      trailing: trailing,
    );
  }



}


