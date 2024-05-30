import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(NotificationApp());
}

class NotificationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotificationScreen(),
      theme: ThemeData(
        primaryColor: Colors.blue[900],
      ),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<Map<String, String>>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = _fetchNotifications();
  }

  Future<List<Map<String, String>>> _fetchNotifications() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return [
      {
        'title': 'Cycling Team',
        'message': 'An Adventure is waiting for you ...',
        'time': '05:19 PM',
      },
      {
        'title': 'Let\'s Hike Group',
        'message': 'An Adventure is waiting for you ...',
        'time': '02:47 PM',
      },
      {
        'title': 'Cycling Team',
        'message': 'An Adventure is waiting for you ...',
        'time': '05:19 PM',
      },
      {
        'title': 'Let\'s Hike Group',
        'message': 'An Adventure is waiting for you ...',
        'time': '02:47 PM',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.person, color: Colors.blue[900]),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Handle more options
            },
          ),
        ],
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 24),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return   Center(child: CircularProgressIndicator(color: Colors.blue[900]));
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching notifications'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off, color: Colors.grey, size: 100),
                  SizedBox(height: 16),
                  Text('No notifications yet', style: TextStyle(color: Colors.grey, fontSize: 18)),
                ],
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final notification = snapshot.data![index];
                return _buildNotificationCard(
                  notification['title']!,
                  notification['message']!,
                  notification['time']!,
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildNotificationCard(String title, String message, String time) {
    return GestureDetector(
      onTap: () {
        if (kDebugMode) {
          print(title);
        }
      },
      child: Card(
        color: Colors.grey[100],
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue[900],
            child: Text(
              title[0],
              style: const TextStyle(color: Colors.white, fontSize: 24.0),
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(message),
          trailing: Text(
            time,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
