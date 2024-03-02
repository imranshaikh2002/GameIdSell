import 'package:flutter/material.dart';
import 'package:gamezone/TabPages/home_page.dart';
import 'package:gamezone/TabPages/notification_page.dart';
import 'package:gamezone/TabPages/profile_page.dart';
import 'package:gamezone/TabPages/sell_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;
  @override
  void initState() {
    _controller = TabController(length: 4, vsync: this)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: const Text("GameZone"),
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: ClipOval(
            child: Image(
              image: AssetImage('assets/images/launcher.jpg'),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Color.fromARGB(201, 255, 255, 255),
              size: 25,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _controller,
          tabs: [
            const Tab(
              icon: Icon(Icons.home),
            ),
            const Tab(
              icon: Icon(Icons.sell),
            ),
            const Tab(
              icon: Icon(Icons.notifications),
            ),
            Tab(
              child: IconButton(
                onPressed: () {},
                icon: const CircleAvatar(
                  backgroundImage: AssetImage("assets/images/user.jpg"),
                ),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: const [
          HomePage(),
          SellPage(),
          TrendingPage(),
          ProfilePage(),
        ],
      ),
    );
  }
}
