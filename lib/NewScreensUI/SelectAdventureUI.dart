import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adventure Selector',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AdventureDetails(),
    );
  }
}

class AdventureDetails extends StatefulWidget {
  const AdventureDetails({super.key});

  @override
  _AdventureDetailsState createState() => _AdventureDetailsState();
}

class _AdventureDetailsState extends State<AdventureDetails> {
  List<Adventure> adventures = [
    Adventure("Service Provider 1", "Moderate", "Both Genders", "2024/05/05", 30, 4.0, 40),
    Adventure("Service Provider 2", "Easy", "Both Genders", "2024/05/05", 100, 5.0, 42),
    Adventure("Service Provider 3", "Challenging", "Both Genders", "2024/05/05", 70, 3.0, 42),
  ];

// Soring ---------


  void sortByPrice() {
    setState(() {
      adventures.sort((a, b) => a.price.compareTo(b.price));
    });
  }

  int difficultyValue(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return 1;
      case 'Moderate':
        return 2;
      case 'Challenging':
        return 3;
      default:
        return 0; // Unknown difficulty
    }
  }

  void sortByDifficulty() {
    setState(() {
      adventures.sort((a, b) => difficultyValue(a.difficulty).compareTo(difficultyValue(b.difficulty)));
    });
  }

  void sortByRating() {
    setState(() {
      adventures.sort((a, b) => b.rating.compareTo(a.rating)); // Sort by descending order
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar:  PreferredSize(
        preferredSize: Size.fromHeight(170.0), // Set the height of the AppBar
       child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.blue[900],
              title: Row(
                children: [
               Text('Select an Adventure' , style: TextStyle(color: Colors.white),),
               Spacer(),
                  IconButton(
                    icon: Icon(Icons.filter_alt, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 8,),
            Padding(
              padding: const EdgeInsets.only( left: 10.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: sortByPrice,
                    child: Text('Sort by Price', style: TextStyle(color: Colors.blue[900]),),
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
                  SizedBox(width: 8,),
                  ElevatedButton(
                    onPressed: sortByDifficulty,
                    child: Text('Sort by Difficulty', style: TextStyle(color: Colors.blue[900]),),
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only( left: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: sortByRating,
                    child: Text('Sort by Rating', style: TextStyle(color: Colors.blue[900]),),
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
                ],
              ),
            ),
          ],
       )
    ),


      backgroundColor: const Color(0xFFeaeaea),
      body: ListView.builder(
        itemCount: adventures.length,
        itemBuilder: (context, index) {
          return  Card(
            color: Colors.white,
            margin: const EdgeInsets.only(left: 10, right: 10 , bottom: 8 ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blue[900],
                        child: const Icon(Icons.person, color: Colors.white,)
                         ),

                      const SizedBox(width: 10,),
                      // Provider name
                      Expanded(  // Wrap the Text widget with Expanded
                        child: Text(adventures[index].provider,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false, // Ensures that the text does not wrap and uses ellipsis instead

                        ),

                      ),

                   // reviews
                      Column(
                        children: [
                          Text("${adventures[index].rating.toStringAsFixed(1)} (${adventures[index].reviews} reviews)",
                              style: const TextStyle(color: Colors.black54)),
                          RatingBarIndicator(
                            rating: adventures[index].rating,
                            itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
                            itemCount: 5,
                            itemSize: 24.0,
                            direction: Axis.horizontal,
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20 ),
                  Text("Difficulty: ${adventures[index].difficulty}", style: const TextStyle(fontSize: 16)),
                  Text("Gender: ${adventures[index].gender}", style: const TextStyle(fontSize: 16)),
                  Text("End Date: ${adventures[index].endDate}", style: const TextStyle(fontSize: 16)),
                  Text("Price: \$${adventures[index].price} / Per Person", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                  const Divider(),
                  const SizedBox(height: 10),

                  // Location and select button
                  Row(
                    children: [
                        Icon(Icons.location_on_outlined, color: Colors.blue[900],),
                      const SizedBox(width: 8), // Add some spacing between the icon and the text
                      const Expanded(  // Wrap the Text widget with Expanded
                        child: Text(
                          'Location of the Adventure',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16),
                          softWrap: false, // Ensures that the text does not wrap and uses ellipsis instead
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[900],
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: const Text('Select', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  )



                ],
              ),
            ),
          );
        },
      ),
    );

  }
}

class Adventure {
  String provider;
  String difficulty;
  String gender;
  String endDate;
  int price;
  double rating;
  int reviews;

  Adventure(this.provider, this.difficulty, this.gender, this.endDate, this.price, this.rating, this.reviews);
}


