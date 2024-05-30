import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyAdventuresScreen(),
      theme: ThemeData(
        primaryColor: Colors.blue[900],
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black54, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.black54, fontSize: 14),
          titleLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
      ),
    );
  }
}

class MyAdventuresScreen extends StatefulWidget {
  @override
  _MyAdventuresScreenState createState() => _MyAdventuresScreenState();
}

enum AdventureStatus { booked, favorite, canceled }

class _MyAdventuresScreenState extends State<MyAdventuresScreen> {
  AdventureStatus _selectedSegment = AdventureStatus.booked;
  final Color _backgroundColor = const Color(0xFFeaeaea);
  final Color _buttonColor = Colors.blue[900]!;
  final double _buttonRadius = 40.0;

  List<Map<String, dynamic>> adventures = List.generate(
    10,
        (index) => {
      'title': 'Service Provider ${index + 1}',
      'difficulty': index % 2 == 0 ? 'Easy' : 'Challenging',
      'gender': index % 2 == 0 ? 'Only Males' : 'Only Females',
      'endDate': '2024/05/05',
      'price': Random().nextInt(100) + 50,
      'status': index % 3 == 0
          ? 'Favorite'
          : index % 3 == 1
          ? 'Booked'
          : 'Favorite', // Changed 'Canceled' to 'Favorite' to keep 'Canceled' segment empty
      'rating': Random().nextDouble() * 5,
      'reviews': Random().nextInt(100),
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "My Adventures",
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: CupertinoPageScaffold(
        backgroundColor: const Color(0xFFeaeaea),
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          middle: CupertinoSlidingSegmentedControl<AdventureStatus>(
            backgroundColor: CupertinoColors.systemGrey2,
             thumbColor:   CupertinoColors.systemBlue.color.withGreen(13).withBlue(161).withRed(13),
            groupValue: _selectedSegment,
            onValueChanged: (AdventureStatus? value) {
              if (value != null) {
                setState(() {
                  _selectedSegment = value;
                });
              }
            },
            children: const <AdventureStatus, Widget>{
              AdventureStatus.booked: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Booked',
                  style: TextStyle(color: CupertinoColors.white),
                ),
              ),
              AdventureStatus.favorite: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Favorite',
                  style: TextStyle(color: CupertinoColors.white),
                ),
              ),
              AdventureStatus.canceled: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Canceled',
                  style: TextStyle(color: CupertinoColors.white),
                ),
              ),
            },
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(4.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: _getFilteredAdventures().isNotEmpty
                  ? _getFilteredAdventures().map((adventure) => _buildAdventureCard(adventure)).toList()
                  : [
                const SizedBox(height: 100),
                const Icon(
                  CupertinoIcons.cloud,
                  size: 100,
                  color: Colors.grey,
                ),
                Text(
                  _getNoAdventuresText(),
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredAdventures() {
    String status;
    switch (_selectedSegment) {
      case AdventureStatus.favorite:
        status = 'Favorite';
        break;
      case AdventureStatus.canceled:
        return []; // Return an empty list for the 'Canceled' segment
      case AdventureStatus.booked:
        status = 'Booked';
        break;
    }
    return adventures.where((adventure) => adventure['status'] == status).toList();
  }

  String _getNoAdventuresText() {
    switch (_selectedSegment) {
      case AdventureStatus.booked:
        return 'No adventure is booked yet.';
      case AdventureStatus.favorite:
        return 'No adventures added to your favorite List.';
      case AdventureStatus.canceled:
        return 'No adventure is canceled.';
      default:
        return 'No adventure is available.';
    }
  }

  Widget _buildAdventureCard(Map<String, dynamic> adventure) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
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
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      adventure['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "${adventure['rating'].toStringAsFixed(1)} (${adventure['reviews']} reviews)",
                        style: const TextStyle(color: Colors.black54),
                      ),
                      RatingBarIndicator(
                        rating: adventure['rating'],
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
              Text("Difficulty: ${adventure['difficulty']}", style: const TextStyle(fontSize: 16)),
              Text("Gender: ${adventure['gender']}", style: const TextStyle(fontSize: 16)),
              Text("End Date: ${adventure['endDate']}", style: const TextStyle(fontSize: 16)),
              Text("Price: \$${adventure['price']} / Per Person", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
              const Divider(),
              const SizedBox(height: 5),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: Colors.blue[900],
                  ),
                  const SizedBox(width: 5),
                  const Expanded(
                    child: Text(
                      'Location of the Adventure',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16),
                      softWrap: false,
                    ),
                  ),
                  _buildActionButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    String buttonText;
    Color buttonColor;
    VoidCallback? onPressed;

    switch (_selectedSegment) {
      case AdventureStatus.booked:
        buttonText = "Booked";
        buttonColor = Colors.grey;
        onPressed = null;
        break;
      case AdventureStatus.favorite:
        buttonText = "Select";
        buttonColor = _buttonColor;
        onPressed = () {
          // Handle select button press
        };
        break;
      case AdventureStatus.canceled:
        buttonText = "Canceled";
        buttonColor = Colors.grey;
        onPressed = null;
        break;
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_buttonRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(buttonText, style: const TextStyle(fontSize: 16, color: Colors.white)),
    );
  }
}
