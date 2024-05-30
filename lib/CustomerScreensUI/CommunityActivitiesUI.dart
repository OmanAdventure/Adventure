import 'package:flutter/material.dart';

void main() {
  runApp(const CommunityActivitiesApp());
}

class CommunityActivitiesApp extends StatelessWidget {
  const CommunityActivitiesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CommunityActivitiesScreen(),
    );
  }
}

class Activity {
  final String title;
  final String date;
  final String time;
  final String location;
  final bool isFree;
  final String phoneNumber;

  Activity({
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.isFree,
    required this.phoneNumber,
  });
}

class CommunityActivitiesScreen extends StatefulWidget {
  const CommunityActivitiesScreen({super.key});

  @override
  _CommunityActivitiesScreenState createState() => _CommunityActivitiesScreenState();
}

class _CommunityActivitiesScreenState extends State<CommunityActivitiesScreen> {
  late Future<List<Activity>> _activitiesFuture;

  @override
  void initState() {
    super.initState();
    _activitiesFuture = _fetchActivities();
  }

  Future<List<Activity>> _fetchActivities() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return [

      Activity(
        title: 'Wadi Bani Omar Walking Group',
        date: 'Friday, December 16, 2023',
        time: '09:51 AM - 16:24 PM',
        location: 'Walayat Saham, Oman',
        isFree: true,
        phoneNumber: '+968 9900 9900',
      ),
      Activity(
        title: 'Al Mouj Muscat Walking for Charity',
        date: 'Friday, December 16, 2023',
        time: '09:51 AM - 16:24 PM',
        location: 'Muscat, Oman',
        isFree: true,
        phoneNumber: '+968 9900 9900',
      ),
      Activity(
        title: 'Ibri Walking Group',
        date: 'Friday, December 16, 2023',
        time: '09:51 AM - 16:24 PM',
        location: 'Ibri, Oman',
        isFree: true,
        phoneNumber: '+968 9900 9900',
      ),

    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFeaeaea),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Community Activities', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<List<Activity>>(
        future: _activitiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return   Center(child: CircularProgressIndicator( color: Colors.blue[900],));
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching activities'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(Icons.cloud_off, color: Colors.grey, size: 100),
                  SizedBox(height: 16),
                  Text('No activities are listed yet.', style: TextStyle(color: Colors.grey, fontSize: 18)),
                  Text('We will list new activities soon.', style: TextStyle(color: Colors.grey, fontSize: 18)),
                  Text('Please come back to check again', style: TextStyle(color: Colors.grey, fontSize: 18)),
                ],
              ),
            );
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: snapshot.data!.map((activity) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(activity.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.blue[900]),
                            const SizedBox(width: 10),
                            Text(activity.date),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.blue[900]),
                            const SizedBox(width: 10),
                            Text(activity.time),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.blue[900]),
                            const SizedBox(width: 10),
                            Text(activity.location),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(activity.isFree ? 'Free' : 'Paid', style: const TextStyle(color: Colors.green)),
                            ElevatedButton.icon(
                              onPressed: _showDirectionAlert,
                              icon: const Icon(Icons.directions, color: Colors.white),
                              label: const Text('Get Direction', style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                backgroundColor: Colors.blue[900],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.phone, color: Colors.blue[900]),
                              onPressed: () => _showCallAlert(activity.phoneNumber),
                            ),
                            IconButton(
                              icon: Icon(Icons.share, color: Colors.blue[900]),
                              onPressed: () {
                                // Handle share action
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }

  void _showDirectionAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.map, color: Colors.green),
              SizedBox(width: 10),
              Text('Open in Google Maps'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Gathering Location'),
                trailing: Icon(Icons.open_in_new, color: Colors.blue[900]),
                onTap: () {
                  // Handle tap
                },
              ),
              ListTile(
                title: const Text('Activity Location'),
                trailing: Icon(Icons.open_in_new, color: Colors.blue[900]),
                onTap: () {
                  // Handle tap
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
          ],
        );
      },
    );
  }

  void _showCallAlert(String phoneNumber) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.phone, color: Colors.blue[900]),
              const SizedBox(width: 10),
              const Text('Call'),
            ],
          ),
          content: Text(phoneNumber, style: const TextStyle(fontSize: 24)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              child: const Text('Call', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
