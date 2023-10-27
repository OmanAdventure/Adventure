import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/main.dart';



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
    // Create a TextEditingController to get the user input
    TextEditingController phoneNumberController = TextEditingController();

    // Show a dialog to allow the user to edit the phone number
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Phone Number"),
        content: TextField(
          controller: phoneNumberController,
          decoration: InputDecoration(labelText: "New Phone Number"),
          keyboardType: TextInputType.phone,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Cancel button
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {

              Navigator.of(context).pop(phoneNumberController.text); // Save button
            },
            child: Text("Save"),
          ),
        ],
      ),
    );

    // Get the new phone number from the TextEditingController
    String newPhoneNumber = phoneNumberController.text.trim();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      print('Current User ID: $userId');
      if (newPhoneNumber.isNotEmpty &&  userId.isNotEmpty) {
        try {
          String userId = user.uid; // Use the stored _user variable here
          print('Current User ID : 2 ');
          print(_user.id);
          print("New Phone Number: ======================================== $newPhoneNumber");
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userId)
              .update({"Phone Number": newPhoneNumber});
          // Fetch and update the displayed user data
          setState(() {
            _userDataFuture = _fetchUserData(userId);
          });
        } catch (e) {
          print("Error updating phone number: $e");
        }
      }
    } else {
      print('No user is currently logged in.');
    }
  }

  // To fetch data once the phone number is updated
  Future<UserModelProfile> _fetchUserData(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await FirebaseFirestore.instance.collection("users").doc(userId).get();

      return UserModelProfile(
        userName: userSnapshot.data()?["userName"] ?? "",
        id: userId,
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
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: FutureBuilder<UserModelProfile>(
          future: _userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              final UserModelProfile user = snapshot.data!;
              return Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView(
                    padding: EdgeInsets.all(16),
                    children: <Widget>[
                      ListTile(
                        title: const Text("User Name"),
                        subtitle: Text(user.userName),
                      ),
                      ListTile(
                        title: const Text("Email"),
                        subtitle: Text(user.email),
                      ),
                      ListTile(
                        title: const Text("Phone Number"),
                        subtitle: Text(user.phoneNumber),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: _editPhoneNumber,
                        ),
                      ),
                      ListTile(
                        title: const Text("Gender"),
                        subtitle: Text(user.gender),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
