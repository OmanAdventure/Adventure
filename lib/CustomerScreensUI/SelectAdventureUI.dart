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
     //  title: 'Adventure Selector',
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
  late Future<List<Adventure>> _adventuresFuture;

  @override
  void initState() {
    super.initState();
    _adventuresFuture = _fetchAdventures();
  }

  Future<List<Adventure>> _fetchAdventures() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    return [
      Adventure("Service Provider 1", "Moderate", "Both Genders", "2024/05/05", 30, 4.0, 40),
      Adventure("Service Provider 2", "Easy", "Both Genders", "2024/05/05", 100, 5.0, 42),
      Adventure("Service Provider 3", "Challenging", "Both Genders", "2024/05/05", 70, 3.0, 42),
    ];
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

  void sortByPrice(List<Adventure> adventures) {
    setState(() {
      adventures.sort((a, b) => a.price.compareTo(b.price));
    });
  }

  void sortByDifficulty(List<Adventure> adventures) {
    setState(() {
      adventures.sort((a, b) => difficultyValue(a.difficulty).compareTo(difficultyValue(b.difficulty)));
    });
  }

  void sortByRating(List<Adventure> adventures) {
    setState(() {
      adventures.sort((a, b) => b.rating.compareTo(a.rating)); // Sort by descending order
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(170.0), // Set the height of the AppBar
        child: Column(
          children: [
            AppBar(
             // backgroundColor: Colors.blue[900],
              centerTitle: true,
              title: Row(
                children: [
                    Text(
                    'Select an Adventure',
                    style: TextStyle( ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon:   Icon(Icons.filter_alt, color: Colors.blue[900]),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final adventures = await _adventuresFuture;
                      sortByPrice(adventures);
                    },
                    child:   Text(
                      'Sort by Price',
                      style: TextStyle(color: Colors.blue[900]),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xff0d47a1), width: 2.0), // Set the border color and width
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0), // Set the border radius if needed
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final adventures = await _adventuresFuture;
                      sortByDifficulty(adventures);
                    },
                    child:   Text(
                      'Sort by Difficulty',
                      style: TextStyle(color: Colors.blue[900]),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xff0d47a1), width: 2.0), // Set the border color and width
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0), // Set the border radius if needed
                      ),
                    ),
                  ),
                ],
              ),
            ),
              Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final adventures = await _adventuresFuture;
                      sortByRating(adventures);
                    },
                    child:   Text(
                      'Sort by Rating',
                      style: TextStyle(color: Colors.blue[900]),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xff0d47a1), width: 2.0), // Set the border color and width
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0), // Set the border radius if needed
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFeaeaea),
      body: FutureBuilder<List<Adventure>>(
        future: _adventuresFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return   Center(child: CircularProgressIndicator(color: Colors.blue[900]));
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching adventures'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_off, color: Colors.grey, size: 100),
                  const SizedBox(height: 16),
                  const Text('No adventures are listed yet', style: TextStyle(color: Colors.grey, fontSize: 18)),
                ],
              ),
            );
          } else {
            final adventures = snapshot.data!;
            return ListView.builder(
              itemCount: adventures.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(left: 10, right: 10, bottom: 8),
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
                              child: const Icon(Icons.person, color: Colors.white),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                adventures[index].provider,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                                softWrap: false, // Ensures that the text does not wrap and uses ellipsis instead
                              ),
                            ),
                            Column(
                              children: [
                                Text("${adventures[index].rating.toStringAsFixed(1)} (${adventures[index].reviews} reviews)",
                                    style: const TextStyle(color: Colors.black54)),
                                RatingBarIndicator(
                                  rating: adventures[index].rating,
                                  itemBuilder: (context, index) => Icon(Icons.star, color: Colors.blue[900]),
                                  itemCount: 5,
                                  itemSize: 24.0,
                                  direction: Axis.horizontal,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text("Difficulty: ${adventures[index].difficulty}", style: const TextStyle(fontSize: 16)),
                        Text("Gender: ${adventures[index].gender}", style: const TextStyle(fontSize: 16)),
                        Text("End Date: ${adventures[index].endDate}", style: const TextStyle(fontSize: 16)),
                        Text("Price: \$${adventures[index].price} / Per Person", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                        const Divider(),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, color: Colors.blue[900]),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Location of the Adventure',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 16),
                                softWrap: false,
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
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
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
