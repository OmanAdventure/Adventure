import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/main.dart';
import 'SettingsScreen.dart';
import 'PhotoContainerScreen.dart';
import 'Notifications.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const int invisibleIndex = -1;


  @override
  HomeScreenState createState() => HomeScreenState();

  static HomeScreenState? findHomeScreenState(BuildContext context) {
    return context.findAncestorStateOfType<HomeScreenState>();
  }

}

class HomeScreenState extends State<HomeScreen> {

  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    if (currentuser.isNotEmpty) {
      setState(() {
        currentIndex = 0;
      });
      print(currentuser);
    }
  }

  final List<Widget> viewContainer = [
      Center(child: adventuresfunc(currentIndex: 0)),
      const Notifications(),
      Settings()
  ];

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.darkMode;
    const darkModeColor = Color(0xFF5A5A5A);

    const categoryIconOutlined = Icon(Icons.category_outlined);
    const notificationsIconOutlined = Icon(Icons.notifications_outlined);
    const settingsIconOutlined = Icon(Icons.settings_outlined);

    const categoryIcon = Icon(Icons.category);
    const notificationsIcon = Icon(Icons.notifications);
    const settingsIcon = Icon(Icons.settings);

    void onTabTapped(int index) {
      setState(() {
        currentIndex = index;
      });
    }


    return Scaffold(
      backgroundColor: Colors.white,
      body: viewContainer[currentIndex],
      bottomNavigationBar: Visibility(
         visible: true,
        // Set visibility based on currentIndex
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          child: BottomNavigationBar(
            backgroundColor: isDarkMode ? darkModeColor : Color(0xFF700464),
            onTap: onTabTapped,
            currentIndex: currentIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.7),
            items: [
              BottomNavigationBarItem(
                icon: currentIndex == 0 ? categoryIcon : categoryIconOutlined,
                label: "Adventures",
              ),
              BottomNavigationBarItem(
                icon: currentIndex == 1 ? notificationsIcon : notificationsIconOutlined,
                label: "Notifications",
              ),
              BottomNavigationBarItem(
                icon: currentIndex == 2 ? settingsIcon : settingsIconOutlined,
                label: "Settings",
              ),
            ],
            selectedIconTheme: const IconThemeData(
              color: Colors.white,
            ),
            unselectedIconTheme: const IconThemeData(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
