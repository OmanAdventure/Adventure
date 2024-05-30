import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CustomerRatingScreen(),
    );
  }
}

class CustomerRatingScreen extends StatefulWidget {
  @override
  _CustomerRatingScreenState createState() => _CustomerRatingScreenState();
}

class _CustomerRatingScreenState extends State<CustomerRatingScreen> {
  // Dynamic variables for rating and comment
  int rating = 5;
  String comment = "Excellent service!";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        title: Text('My customer Rating', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                // Image Section

                Container(
                  height: 500,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/cyclists.jpg"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),


                Column(
                  children: [
                    SizedBox(height: 400), // Adjust this height to position the container correctly
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30.0),
                      padding: const EdgeInsets.all(30.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Text('My Rating', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 25),
                          // Star Ratings
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              return Icon(
                                index < rating ? Icons.star : Icons.star_border,
                                color: Colors.blue[900],
                                size: 30,
                              );
                            }),
                          ),
                          SizedBox(height: 20),
                          Text(comment, style: TextStyle(fontSize: 18)),
                          SizedBox(height: 50),
                          // Share Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              IconButton(

                                onPressed: (){

                                },
                                icon:  Icon(Icons.share, size: 30, color: Colors.blue[900],),
                              ),
                            ],
                          )

                        ],
                      ),
                    ),
                  ],
                ),


              ],
            ),
            // Additional content can be added here
          ],
        ),
      ),
    );
  }
}
