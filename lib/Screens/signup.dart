import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'email_login.dart';
import 'email_signup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/icon_map.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SignUp extends StatelessWidget {

  static const String routeName = '/SignUp';
  final String title = "Let's Adventure";
  final Icon icons = const Icon(Icons.hiking);

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    final appBarColor = themeProvider.darkMode
        ? themeProvider.darkTheme.primaryColor
        : Color(0xFF700464);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: appBarColor,

         // title: Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white,),),

             actions: [
                IconButton(
                color: Colors.white,
                padding: const EdgeInsets.only(left: 100),
                onPressed: () {},
                icon: const Icon(Icons.hiking),),
                Spacer(),
               Text(title, textAlign: TextAlign.center,
                 style: const TextStyle(color: Colors.white, fontSize: 20),
               ),


               Spacer(),
               IconButton(
                  color: Colors.white,
               padding: const EdgeInsets.only(right: 100),
               icon:   Icon(MdiIcons.fromString("flag")),
               onPressed: () {},
             ),

             ],
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                const Padding(
                   padding: EdgeInsets.all(10.0),
                   child: Text(
                     'Wathbah',
                   style: TextStyle(
                   fontSize: 50,
                   fontWeight: FontWeight.bold,
                   fontStyle: FontStyle.normal,
                   color: Color(0xFF700464),
                    ),
                 ),
            ),
                 // if (FirebaseAuth.instance.currentUser == null) // Check if user is logged in
            Padding (
                padding: const EdgeInsets.all(10.0),
                child: SignInButton(
                  Buttons.Email,
                  text: "Sign up with Email",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpScreen(sourceScreen: 'HomeScreen')),
                    );
                  },
                )),


            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SignInButtonBuilder(
                text: 'Sign In With Email',
                icon: Icons.email,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmailLogIn()),
                  );
                },
                backgroundColor: Color(0xFF700464),
                width: 220.0,
              ),
            ),

          ]),
        ),
      bottomNavigationBar:  null, // Set bottomNavigationBar to null to remove it


    );
  }
}