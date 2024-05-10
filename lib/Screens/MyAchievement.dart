import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:untitled/Screens/form_completed.dart';
import 'package:untitled/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
/*
void main() {
  runApp(
      const MaterialApp(
        home: PointsBadgesScreen(

        ),
      )
  );
}
*/

class PointsBadgesScreen extends StatefulWidget {


   final String uuid;
  final String adventureID;
   final String  adventureProviderName ;
  final String typeOfAdventure ;
  final String difficultyLevel ;
  final String price;


   const PointsBadgesScreen({Key? key,

      required this.uuid,
     required this.adventureID,
      required this.adventureProviderName,
     required this.typeOfAdventure,
     required this.difficultyLevel,
     required this.price,

   }) : super(key: key);



  @override
  PointsBadgesScreenState createState() => PointsBadgesScreenState();
}

class PointsBadgesScreenState extends State<PointsBadgesScreen> with TickerProviderStateMixin {
  int userPoints = 19000; // Replace with the actual points value
  int userEarnedPoints = 10; // Replace this with the actual variable holding the earned points
  List<BadgeInfo> userBadges = adventureBadges;
  int numUnlockedBadges = 0;
  late String memberType ;
  late AnimationController _controller;
  late Animation<double> _animation;

  late Stream<QuerySnapshot> _adventuresAnalyticsStream;


  @override
  void initState() {
    super.initState();


    updateUnlockedBadgesCount();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {}); // Update the UI when animation value changes
      });
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void updateUnlockedBadgesCount() {
    setState(() {
      numUnlockedBadges = countUnlockedAdventures();


      if(userPoints  <= 1000 ){
        memberType = 'Silver Member';
      }
      else if(userPoints  <= 2000 ){
        memberType = 'Gold Member';
      }
      else if(userPoints  >= 5000 ){
        memberType = 'Platinum Member';
      }

    });
  }

  int countUnlockedAdventures() {
    return userBadges.where((badge) => badge.isUnlocked).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Achievements', style: TextStyle(fontSize: 25, color: Colors.white),),
        centerTitle: true,
        backgroundColor:const Color(0xFF700464),
      ),
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            SizedBox(
              width: double.maxFinite,
              height: 180,
              child:   Card(
                elevation: 5,
                child:  Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // My Reward card
                          Row(
                            children: [
                              const Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10 ) ,
                              child:  Text(
                                  'My Reward Card',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF700464),
                                    fontStyle: FontStyle.italic,),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10), // Adjust the value as needed
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                     memberType,
                                    softWrap: true,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF700464),
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              )



                            ]
                        ),
                          Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                             const SizedBox(width: 16,),

                            Container(

                               padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '$userPoints',
                                style: const TextStyle(
                                  color: Color(0xFF700464),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          // Add spacing between the circle and text
                             const Text(
                              'Points',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),


                           const Spacer(),

                            Stack(
                              children: <Widget>[
                                Transform(
                                  transform: Matrix4.rotationY(_animation.value * pi * 2),
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    'assets/images/awardBadge.png', // Replace with your image asset
                                    width: 100, // Adjust width as needed
                                    height: 100, // Adjust height as needed
                                  ),
                                ),
                                Positioned(
                                  bottom: 32.0,
                                  left: 41.0,
                                  child: Text(
                                    '$numUnlockedBadges',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),


                          ],
                        ),
                      ]
                  ),
              ),
            ),
/*
            const SizedBox(
              width: double.maxFinite,
              height: 300,
              child:   Card(
                elevation: 5,
                child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10 ) ,
                              child:  Text(
                                'Analytics',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF700464),
                                  fontStyle: FontStyle.italic,),
                              ),
                            ),
                          ]
                      ),

                      Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 10 ) ,
                              child:  Text(
                                'Number of Adventures booked \n Hiking: \n Cycling: \n Beach Adventure: \n Horse Riding:' ,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,),
                              ),
                            ),
                          ]
                      ),

                      Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 10 ) ,
                              child:  Text(
                                'Difficulty level \n Easy: \n Moderate: \n Challenging: ' ,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,),
                              ),
                            ),
                          ]
                      ),
                    ]
                ),
              ),
            ),
*/
            const SizedBox(height: 8),

            Column(
              children: userBadges.map((badge) {
                final index = userBadges.indexOf(badge);
                final precedingBadge = index > 0 ? userBadges[index - 1] : null;
                badge.isUnlocked = precedingBadge != null && precedingBadge.isUnlocked && precedingBadge.progress >= precedingBadge.requiredProgress;
                return ExpandableBadgeWidget(badge);
              }).toList(),
            ),








          ],
        ),
      ),
    )
    );
  }
}


class ExpandableBadgeWidget extends StatelessWidget {
  final BadgeInfo badge;

  const ExpandableBadgeWidget(this.badge, {super.key}  );

  @override
  Widget build(BuildContext context) {
    // Determine if the badge is unlocked based on userEarnedPoints and requiredProgress
    badge.isUnlocked = badge.userEarnedPoints >= badge.requiredProgress;
    ///  the isUnlocked property is determined by comparing badge.userEarnedPoints with badge.requiredProgress.
    ///  If the user has earned enough points to meet or exceed the required progress,
    ///  the badge is considered unlocked. The progress bar will be filled, and the color will be blue.

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: BadgeTileHeader(badge),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My award:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  badge.description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: badge.isUnlocked ? 1.0 : badge.userEarnedPoints / badge.requiredProgress,
                  valueColor: badge.isUnlocked
                      ? const AlwaysStoppedAnimation<Color>(Color(0xFF700464))
                      : null, // Set to null for the default color
                ),
                const SizedBox(height: 8),
                Text(
                  'Progress: ${badge.userEarnedPoints}/${badge.requiredProgress}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class BadgeTileHeader extends StatelessWidget {

  final BadgeInfo badge;
  const BadgeTileHeader(this.badge, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          badge.icon,
          size: 36,
          color: badge.isUnlocked ? const Color(0xFF700464) : Colors.grey, // Customize the badge icon color
        ),
        const SizedBox(width: 8),
        if (!badge.isUnlocked) // Conditionally show lock icon if not unlocked
          const Icon(
            Icons.lock,
            color: Colors.grey,
          ),
        const SizedBox(width: 8), // Adjust the spacing between icon and text
        Text(
          badge.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: badge.isUnlocked ? const Color(0xFF700464) : Colors.grey, // Customize the text color
          ),
        ),
      ],
    );
  }
}


class BadgeInfo {
  final String name;
  final IconData icon;
  final String description;
  final int userEarnedPoints;
  bool isUnlocked;
  final int progress;
  final int requiredProgress;

  // Constructor with an optional parameter for isUnlocked
  BadgeInfo(
      this.name,
      this.icon,
      this.description, {
        required this.userEarnedPoints,
        required this.isUnlocked,
        this.progress = 0, // Default value for progress
        this.requiredProgress = 50, // Default value for requiredProgress
      });

  // Additional constructor if you want to provide different values for progress and requiredProgress
  BadgeInfo.withCustomValues(
      this.name,
      this.icon,
      this.description, {
        required this.userEarnedPoints,
        required this.isUnlocked,
        required this.progress,
        required this.requiredProgress,
      });
}

List<BadgeInfo> adventureBadges = [

  // Hiking Badges
  BadgeInfo(
    'Trailblazer Badge',
    Icons.terrain,
    'Awarded to users who explore new trails and paths, showing a pioneering spirit in their outdoor adventures.' ,
    userEarnedPoints: 10,
    isUnlocked: true,
    progress: 5,
    requiredProgress: 10,
  ),
  BadgeInfo(
    'Summit Conqueror Badge',
    Icons.terrain,
    'Earned by users who successfully reach the summit of a mountain during their hiking adventures.',
    userEarnedPoints: 10,
    isUnlocked: true,
    progress: 5,
    requiredProgress: 10,
  ),
  BadgeInfo(
    'Peak Explorer Badge',
    Icons.terrain,
    'Awarded to users who reach the summit of multiple peaks during their hiking adventures.',
    userEarnedPoints: 0,
    isUnlocked: false,
    progress: 0,
    requiredProgress: 0,
  ),
  BadgeInfo(
    'Trail Master Badge',
    Icons.terrain,
    'Given to users who complete a certain number of hiking trails, showcasing their experience and dedication to hiking.',
    userEarnedPoints: 0,
    isUnlocked: false,
    progress: 0,
    requiredProgress: 0,
  ),
  BadgeInfo(
    'Wilderness Navigator Badge',
    Icons.terrain,
    'Recognizes users who navigate through challenging wilderness areas, demonstrating their outdoor survival skills.',
    userEarnedPoints: 0,
    isUnlocked: false,
    progress: 0,
    requiredProgress: 0,
  ),
  BadgeInfo(
    'Nature Photographer Badge',
    Icons.terrain,
    'Awarded to users who capture stunning photographs of wildlife, landscapes, and natural scenery during their hiking trips.',
    userEarnedPoints: 0,
    isUnlocked: false,
    progress: 0,
    requiredProgress: 0,
  ),
  // Horse Riding Badges
  BadgeInfo(
    'Equine Explorer Badge',
    Icons.favorite,
    'Given to users who engage in horse riding adventures, demonstrating a passion for equestrian exploration.',
    userEarnedPoints: 10,
    isUnlocked: false,
    progress: 0,
    requiredProgress: 0,
  ),
  BadgeInfo(
    'Canter Champion Badge',
    Icons.favorite,
    'Awarded to users who master the canter, one of the basic horse riding gaits, demonstrating their riding proficiency.',
    userEarnedPoints: 0,
    isUnlocked: false,
    progress: 0,
    requiredProgress: 0,
  ),

  BadgeInfo(
    'Cross-Country Rider Badge',
    Icons.favorite,
    'Recognizes users who participate in cross-country horse riding events, showcasing their endurance and skill in navigating diverse terrain.',
    userEarnedPoints: 0,
    isUnlocked: false,
    progress: 0,
    requiredProgress: 0,
  ),
  BadgeInfo(
    'Horse Whisperer Badge',
    Icons.favorite,
    'Given to users who develop a strong bond and communication with their horses, demonstrating empathy and understanding in their equestrian pursuits.',
    userEarnedPoints: 0,
    isUnlocked: false,
    progress: 0,
    requiredProgress: 0,
  ),

  BadgeInfo(
      'Equine Explorer Badge',
      Icons.favorite,
      'Given to users who engage in horse riding adventures, demonstrating a passion for equestrian exploration.',
      userEarnedPoints: 10,
      isUnlocked: false
  ),

  BadgeInfo(
      'Forest Adventurer Badge',
      Icons.terrain,
      'Given to users who immerse themselves in forested areas, showing a commitment to exploring natural woodlands.',
      userEarnedPoints: 0,
      isUnlocked: false
  ),

  BadgeInfo(
    'Summit Conqueror Badge',
    Icons.terrain,
    'Earned by users who successfully reach the summit of a mountain during their hiking adventures.',
    userEarnedPoints: 10,
    isUnlocked: true,
    progress: 5, // Custom progress value for this badge
    requiredProgress: 10, // Custom requiredProgress value for this badge
  ),

  BadgeInfo(
      'Sunset Chaser Badge',
      Icons.wb_sunny,
      'Recognizes users who actively seek and capture beautiful sunset views during their outdoor activities.',
      userEarnedPoints: 10,
      isUnlocked: false
  ),

  BadgeInfo(
    'Cycling Pro Badge',
    Icons.directions_bike,
    'Awarded to cycling enthusiasts who cover long distances or achieve challenging cycling goals.',
      userEarnedPoints: 10,
      isUnlocked: true,

  ),

  BadgeInfo(
    'Seaside Cyclist Badge',
    Icons.directions_bike,
    'Awarded to users who combine cycling with coastal exploration, showcasing a love for beach-side bike rides.',
    userEarnedPoints: 10,
    isUnlocked: true,
    progress: 2, // Custom progress value for this badge
    requiredProgress: 10, // Custom requiredProgress value for this badge
  ),

  BadgeInfo(
    'Century Rider Badge',
    Icons.directions_bike,
    'Awarded for completing a 100-mile cycling ride.',
    userEarnedPoints: 10,
    isUnlocked: false,
    progress: 5,
    requiredProgress: 10,
  ),
  BadgeInfo(
    'Uphill Warrior Badge',
    Icons.directions_bike,
    'Earned by conquering challenging uphill climbs during cycling.',
    userEarnedPoints: 10,
    isUnlocked: false,
    progress: 5,
    requiredProgress: 10,
  ),
  
  BadgeInfo(
    'Shoreline Explorer Badge',
    Icons.directions_bike,
    'Awarded to users who explore and discover new areas along the coastline.',
    userEarnedPoints: 10,
    isUnlocked: false,
    progress: 5,
    requiredProgress: 10,
  ),
  BadgeInfo(
    'Sandcastle Architect Badge',
    Icons.directions_bike,
    'Given to users who demonstrate exceptional skills in building sandcastles on the beach.',
    userEarnedPoints: 10,
    isUnlocked: false,
    progress: 5,
    requiredProgress: 10,
  ),


  BadgeInfo(
    'Waves Master Badge',
    Icons.waves,
    'Awarded to users who excel in water-based adventures, such as surfing, kayaking, or paddle boarding.',
      userEarnedPoints: 0,
      isUnlocked: false
  ),
  BadgeInfo(
    'Coastal Cruiser Badge',
    Icons.waves,
    'Recognizes users who enjoy a variety of coastal activities, including, coastal walks, and seaside picnics.',
      userEarnedPoints: 0,
     isUnlocked: false
  ),

  BadgeInfo(
    'Beach Explorer Badge',
    Icons.waves,
    'Recognizes users who explore and discover new beach destinations, showcasing a love for coastal adventures.',
    userEarnedPoints: 10,
    isUnlocked: true,
    progress: 2, // Custom progress value for this badge
    requiredProgress: 10, // Custom requiredProgress value for this badge
  ),


];


/// ------------------------------ Gamification Part -----------------------------------
Future<Map<String, int>> countUserAdventureReservedAdventures(String userID, String adventureID) async {
  // Reference to the Firestore collection
  CollectionReference bookingsCollection = FirebaseFirestore.instance.collection('BookedAdventure');

  // Query to get the documents for the specified user and adventure
  QuerySnapshot querySnapshot = await bookingsCollection
      .where('userID', isEqualTo: userID)
      .where('adventureID', isEqualTo: adventureID)
      .get();

  // Initialize total number of reserved adventures and number of documents found
  int totalReservedAdventures = 0;
  int numberOfDocuments = querySnapshot.size;

  // Loop through the documents to sum up the NumberOfReservedAdventures
  querySnapshot.docs.forEach((doc) {
    // Cast doc.data() to Map<String, dynamic>
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Check if NumberOfReservedAdventures exists and is not null
    if (data.containsKey('NumberOfReservedAdventures')) {
      // Use try-catch to handle non-integer values gracefully
      try {
        // Convert NumberOfReservedAdventures to int and add to totalReservedAdventures
        int? reservedAdventures = int.tryParse(data['NumberOfReservedAdventures']);
        if (reservedAdventures != null) {
          totalReservedAdventures += reservedAdventures;
        }
      } catch (e) {
        print('Error parsing NumberOfReservedAdventures: $e');
        // Handle error - Maybe log it or skip this document
      }
    }
  });

  // Return a map containing the total number of reserved adventures and the number of documents found
  return {
    'totalReservedAdventures': totalReservedAdventures,
    'numberOfDocuments': numberOfDocuments,
  };
}

Future<Map<String, int>> countUserAdventureTypes(String userID) async {
  // Reference to the Firestore collection
  CollectionReference bookingsCollection = FirebaseFirestore.instance.collection('BookedAdventure');

  // Query to get the documents for the specified user
  QuerySnapshot querySnapshot = await bookingsCollection.where('userID', isEqualTo: userID).get();

  // Initialize a map to store the counts for each adventure type
  Map<String, int> adventureCounts = {
    'Hiking': 0,
    'Horse Riding': 0,
    'Cycling': 0,
    'Beach Adventure': 0,
  };

  // Loop through the documents to count the bookings for each adventure type
  querySnapshot.docs.forEach((doc) {
    // Cast doc.data() to Map<String, dynamic>
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Check if the 'typeOfAdventure' field exists and is not null
    if (data.containsKey('typeOfAdventure')) {
      String? adventureType = data['typeOfAdventure'];
      if (adventureType != null && adventureCounts.containsKey(adventureType)) {
        // Increment the count for the corresponding adventure type
        adventureCounts[adventureType] = (adventureCounts[adventureType] ?? 0) + 1;
      }
    }
  });

  // Print the counts for each adventure type
  adventureCounts.forEach((adventureType, count) {
    print('User $userID has booked $count $adventureType adventures.');
  });
  // Return the map containing the counts for each adventure type
  return adventureCounts;
}
// --------------------------Gamification Ends-------------------------------