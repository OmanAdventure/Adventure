import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'email_login.dart';
import 'email_signup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/icon_map.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


class SignUp extends StatelessWidget {
  final String title = "Let's Adventure";
  final Icon icons = Icon(Icons.hiking);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.teal,
          title: Text(this.title, textAlign: TextAlign.center,),
              leading: IconButton(
                padding: EdgeInsets.only(left: 100),
              onPressed: () {},
              icon: Icon(Icons.hiking),),
             actions: [IconButton(
               padding: EdgeInsets.only(right: 100),
               icon:   Icon(MdiIcons.fromString("flag")),
               onPressed: () {},
             ),],
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
                Padding(
                   padding: const EdgeInsets.all(10.0),
                   child: Text(
                     'Oman Adventure',
                 style: GoogleFonts.satisfy(
                   fontSize: 50,
                 fontWeight: FontWeight.bold,
                 fontStyle: FontStyle.normal,
                 color: Colors.teal,
                    ),
                 ),
            ),
            Padding(
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
                padding: EdgeInsets.all(10.0),
                child: SignInButton(
                  Buttons.Google,
                  text: "Sign up with Google",
                  onPressed: () {},
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
                backgroundColor: Colors.teal,
                width: 220.0,
              ),),
          ]),
        ));
  }
}