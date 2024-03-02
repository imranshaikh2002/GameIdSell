import 'package:flutter/material.dart';
import 'package:gamezone/TabPages/home_page.dart';
import 'package:gamezone/TabPages/notification_page.dart';
import 'package:gamezone/TabPages/profile_page.dart';
import 'package:gamezone/TabPages/sell_page.dart';

class TabPage extends StatefulWidget {
  const TabPage({super.key});

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  late final pages = const [
    HomePage(),
    SellPage(),
    TrendingPage(),
    ProfilePage(),
  ];
  int activePage = 0;

  changePage(int n) {
    if (activePage != n) {
      setState(() {
        activePage = n;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[activePage],
      bottomNavigationBar: BottomNavigationBar(
          selectedLabelStyle: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
          selectedIconTheme: const IconThemeData(color: Colors.red),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 28,
                color: Colors.grey,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.sell,
                size: 28,
                color: Colors.grey,
              ),
              label: "Sell",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications,
                size: 28,
                color: Colors.grey,
              ),
              label: "Trending",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 28,
                color: Colors.grey,
              ),
              label: "Profile",
            ),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: activePage,
          selectedItemColor: Colors.black,
          iconSize: 40,
          onTap: changePage,
          elevation: 5),
    );
  }
}
