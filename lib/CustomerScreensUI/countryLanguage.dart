import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LanguageAndCountrySelector(),
    );
  }
}

class LanguageAndCountrySelector extends StatefulWidget {
  const LanguageAndCountrySelector({super.key});

  @override
  _LanguageAndCountrySelectorState createState() => _LanguageAndCountrySelectorState();
}

class _LanguageAndCountrySelectorState extends State<LanguageAndCountrySelector> {
  bool isEnglish = true; // Initial state for the language toggle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text('Outdoor', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          Padding(padding:  const EdgeInsets.fromLTRB(20, 5, 20, 1),
                 child: Center(
                  child: CustomPaint(
                  size: const Size(200, 200),
                  painter: LogoPainter(),
                   ),
                 ),
              ),

          const Padding(padding:  EdgeInsets.only(bottom: 40),
            child: Center(
              child: Text("Outdoor", style: TextStyle(fontSize: 25 , fontWeight: FontWeight.bold ,
                  fontFamily: 'Times' ),)
            ),
          ),

          Padding(
          padding: const EdgeInsets.fromLTRB(40, 10, 30, 10),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Language' , style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),


          ),
          
          Padding(
            padding: const EdgeInsets.all(10.0),
            child:  GestureDetector(
              onTap: () {
                setState(() {
                  isEnglish = !isEnglish;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(1),
                width: 150,
                height: 50,
                decoration: BoxDecoration(
                    color: isEnglish ? Colors.white : Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.blue[900]!)
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: isEnglish ? 0 : 60,
                      top: 0,
                      right: isEnglish ? 60 : 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[900],
                          borderRadius: BorderRadius.circular(40),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          isEnglish ? 'English' : 'عربي',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ),
        ),
          Expanded(
            child: Center(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: <Widget>[
                    const Text('Choose Adventure Country', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    _buildCountryTile('Oman', Icons.flag_circle),
                    _buildCountryTile('UAE', Icons.flag_circle),
                    _buildCountryTile('KSA', Icons.flag_circle ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryTile(String country, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: const Color(0xFFeaeaea),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40), // Rounded edges for each country button
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue[900]),
        title: Text(country),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: () {
          if (kDebugMode) {
            print('Tapped on $country');
          }
        },
      ),
    );
  }
}


class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = Colors.blue[900]!
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final paint2 = Paint()
      ..color = Colors.blue[900]!
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 80, paint1);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 50, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
