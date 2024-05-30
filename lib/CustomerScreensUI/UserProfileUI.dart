import 'package:flutter/material.dart';
import 'package:untitled/components/CustomAlertUI.dart';

void main() {
  runApp(UserProfileApp());
}

class UserProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserProfileScreen(
        name: 'Fahad Rashed',
        phone: '123-456-7890',
        email: 'example@email.com',
        password: 'ThisIsAPassword',
        gender: 'Male',
      ),
    );
  }
}

class UserProfileScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String email;
  final String password;
  final String gender;

  UserProfileScreen({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.gender,
  });

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {

  void _togglePasswordEditing() {
    showDialog(
      context: context,
      barrierDismissible : false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('Edit Password'),
          content: Text('Do you want to edit the password?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isEditingPassword = false;
                });
              },
              child: Text('No', style: TextStyle(color: Colors.blue[900])),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isEditingPassword = true;
                });
              },
              child: Text('Yes', style: TextStyle(color: Colors.white)),
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  bool _isEditingPassword = false;
  bool _isobscureText = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: Text('My Profile', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blue[900],
                    child: Icon(Icons.person, color: Colors.white, size: 50),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.camera_alt, color: Colors.blue[900], size: 15),
                    ),
                  ),
                ],
              ),
            ),
            /// ---------------New Design ----------------

            const SizedBox(height: 20),
            buildListTile("User Name", widget.name ),
            buildListTile("Email", widget.email),
            buildListTile("Phone Number", widget.phone),
            buildListTile("Phone Number", widget.password,
              trailing:  IconButton(
                icon:   Icon(Icons.edit, color: Colors.blue[900]),
                onPressed:  _togglePasswordEditing,
              ),
            ),
            buildListTile("Gender", widget.gender),
            /// -------------------------------
            ElevatedButton(
              onPressed: _isEditingPassword
                  ? () {

                showDialog(
                  context: context,
                  barrierDismissible : false,
                  builder: (BuildContext context) {
                    return CustomDialog(
                      title: 'Password Reset',
                      message: 'You have updated your password successfully',
                      buttonText: 'OK',
                      onButtonPressed: () {
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );

                setState(() {
                  _isEditingPassword = false;
                });
              }
                  : null,
              child: Text('Save changes' , style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15.0), backgroundColor: Colors.blue[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
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
              borderRadius: BorderRadius.circular(40),
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
