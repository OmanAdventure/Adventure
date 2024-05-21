import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FilterScreen(),
    );
  }
}

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  double rating = 3;
  Map<String, bool> genders = {
    'Male': false,
    'Female': false,
    'Mix': false,
  };
  Map<String, bool> difficulties = {
    'Easy': false,
    'Moderate': false,
    'Challenging': false,
  };

  void _resetFilters() {
    setState(() {
      genders.updateAll((key, value) => false);
      difficulties.updateAll((key, value) => false);
      rating = 0;
    });
  }



  void _applyFilters() {
    // Implement what happens when filters are applied
    Navigator.pop(context); // Just close the screen for now
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filters"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Gender", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ...genders.keys.map((String key) {
                return CheckboxListTile(
                  activeColor: Colors.blue[900],
                  title: Text(key),
                  value: genders[key],
                  onChanged: (bool? value) {  // Adjust the callback to accept a nullable bool
                    if (value != null) {  // Check if the value is not null before using it
                      setState(() {
                        genders[key] = value;
                      });
                    }
                  },
                );

              }).toList(),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 20),
              Text("Level of Difficulty", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ...difficulties.keys.map((String key) {
                return CheckboxListTile(
                  activeColor: Colors.blue[900],
                  title: Text(key),
                  value: difficulties[key],
                  onChanged: (bool? value) {  // Adjust the callback to accept a nullable bool
                    if (value != null) {  // Check if the value is not null before using it
                      setState(() {
                        difficulties[key] = value;
                      });
                    }
                  },
                );

              }).toList(),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 20),
              Text("Rating", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
             Center(
               child:  RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  setState(() {
                    this.rating = rating;
                  });
                },
              ),
                  ),
              SizedBox(height: 50),
              Divider(),
               Padding(
                   padding: EdgeInsets.only(bottom: 10),
                 child:  Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                     ElevatedButton(
                       onPressed: _resetFilters,
                       child: Text("Reset", style: TextStyle(color: Colors.blue[900])),
                       style: ElevatedButton.styleFrom(
                         padding: const EdgeInsets.symmetric(horizontal: 40.0),
                         foregroundColor: Colors.black,
                         backgroundColor: Colors.white,
                         side: const BorderSide(color: Color(0xff0d47a1), width: 2.0),  // Set the border color and width
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(40.0), // Set the border radius if needed
                         ),
                       ),
                     ),

                     ElevatedButton(
                       onPressed: _applyFilters,
                       child: Text("Apply"),
                       style: ElevatedButton.styleFrom(
                         padding: const EdgeInsets.symmetric(horizontal: 40.0,   ),
                         foregroundColor: Colors.white, backgroundColor: Colors.blue[900], // foreground
                       ),
                     ),
                   ],
                 ),

               )


            ],
          ),
        ),
      ),
    );
  }
}


