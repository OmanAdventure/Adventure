import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/Screens/PhotoContainerScreen.dart';
import 'package:untitled/main.dart';
import 'PhotoContainerScreen.dart';

// Define a custom Form widget.
class FormCompleted extends StatefulWidget {
  const FormCompleted({Key? key}) : super(key: key);

  @override
  FormCompletedState createState() => FormCompletedState();
}

// Define a corresponding State class.
// This class holds data related to the form.
class FormCompletedState extends State<FormCompleted> {

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: Text(
          'Adventure Form',
          style: GoogleFonts.satisfy(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
             Padding(
                 padding:EdgeInsets.fromLTRB(20, 200, 20, 3),

             child: Align(
               alignment: Alignment.center,
               child: Text(
                 textAlign: TextAlign.center,
                 'We are so excited for your adventure!\n\n'
                     'You adventure is waiting for you.\n '
                     'Please check your email',
                 style: GoogleFonts.timmana(
                   fontSize: 25,
                   fontWeight: FontWeight.bold,
                   fontStyle: FontStyle.normal,
                    color: Colors.black,
                 ),
                 /// To include a hiking or riding Gif or annimation
               ),
             )


             ),

            Padding(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 30),
              child: ElevatedButton(
                style: ButtonStyle(
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        TextStyle(
                            fontSize: 22, fontWeight: FontWeight.normal)),
                    minimumSize:
                    MaterialStateProperty.all<Size>(Size(400, 50)),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.teal)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => adventuresfunc()),
                  );
                },
                    child: const Text('Back to Activity Dashboard'),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

