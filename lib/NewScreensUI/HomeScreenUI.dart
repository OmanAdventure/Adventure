import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AdventureScreen(),
    );
  }
}

class AdventureScreen extends StatefulWidget {
  @override
  _AdventureScreenState createState() => _AdventureScreenState();
}

class _AdventureScreenState extends State<AdventureScreen> {

  String dropdownValue = 'Oman'; // Initial value


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFeaeaea), // Light grey background color
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0), // Set this height to your preference
        child: AppBar(
         automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.all(20.0),
               child: Icon(Icons.ac_unit, color: Colors.blue[900]),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Welcome', style: TextStyle(color: Colors.black, fontSize: 14)),
                    Text('Fahad Rashid', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
              ),
              Container(
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black), // Blue border around DropdownButton
                  borderRadius: BorderRadius.circular(40),
                ),
                child: DropdownButton<String>(
                  dropdownColor: Colors.white,  // Optional: Changes the background color of the dropdown
                  borderRadius: BorderRadius.circular(40),
                  underline: Container(), // No underline
                  icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                  value: dropdownValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>['Oman', 'Option 2', 'Option 3']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.black)),
                    );
                  }).toList(),
                ),
              ),

              IconButton(
                icon: Icon(Icons.circle, color: Colors.black),
                onPressed: () {},
              ),

            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding(
              padding:  EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Adventures Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
              )
            ),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              children: <Widget>[
                _buildCategoryCard('Horse Riding', 'assets/images/horseback.jpg', () {
                  print('Horse Riding Tapped!');
                }),
                _buildCategoryCard('Hiking', 'assets/images/hiking.jpg', () {
                  print('Hiking Tapped!');
                }),
                _buildCategoryCard('Beach Adventures', 'assets/images/beach.jpg', () {
                  print('Beach Adventures Tapped!');
                }),
                _buildCategoryCard('Cycling', 'assets/images/cycling.jpg', () {
                  print('Cycling Tapped!');
                }),
              ],
            ),
            const SizedBox(height: 20),
            const Padding(
                padding: EdgeInsets.fromLTRB(15, 8, 15, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Community activities, promoting health and wellness', style: TextStyle(fontSize: 18, ),
                )
             ),
            ),
        Padding(
         padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
         child: Container(
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(20), // Rounded edges for the container
          ),
          height: 250,
          width: double.infinity,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20), // Rounded edges for the image
                child: const Image(
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  image: AssetImage('assets/images/beach.jpg'),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue[900],
                    backgroundColor: Colors.white, // Text color of the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {}, // Define what the button does when it is pressed
                  child: const Text('Find More'),
                ),
              ),
            ],
          ),
        ),
      ),
      ],
        ),
      ),

    );
  }


  Widget _buildCategoryCard(String title, String imagePath, VoidCallback onTap) {
    return Padding(
      padding:  EdgeInsets.fromLTRB(15, 10, 15, 8), // Add padding around each card
      child:  GestureDetector(
        onTap: onTap,
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: Colors.white, // Set the background color of the card to white
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Container(
                color: Colors.black.withOpacity(0.5),
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  title,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),


    );
  }



}
