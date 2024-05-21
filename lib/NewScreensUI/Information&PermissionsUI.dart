import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: PermissionsScreen(),
  ));
}

class PermissionsScreen extends StatefulWidget {
  @override
  _PermissionsScreenState createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool _camera = true;
  bool _notifications = true;
  bool _location = true;
  bool _fitnessApp = false;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Information & Permissions', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildSwitchTile(Icons.camera_alt_outlined, 'Camera', _camera, (bool value) {
                  setState(() {
                    _camera = value;
                  });
                }),
                _buildDivider(),
                _buildSwitchTile(Icons.notifications_outlined, 'Notifications', _notifications, (bool value) {
                  setState(() {
                    _notifications = value;
                  });
                }),
                _buildDivider(),
                _buildSwitchTile(Icons.location_on_outlined, 'Location', _location, (bool value) {
                  setState(() {
                    _location = value;
                  });
                }),
                _buildDivider(),
                _buildSwitchTile(Icons.fitness_center_outlined, 'Fitness App', _fitnessApp, (bool value) {
                  setState(() {
                    _fitnessApp = value;
                  });
                }),
                _buildDivider(),
                _buildSwitchTile(Icons.dark_mode_outlined, 'Dark Mode', _darkMode, (bool value) {
                  setState(() {
                    _darkMode = value;
                  });
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[900], size: 28),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue[900],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[300],
      thickness: 1,
      height: 1,
    );
  }
}
