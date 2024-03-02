import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gamezone/IconPages/cart_page.dart';
import 'package:gamezone/IconPages/search_page.dart';
import 'package:gamezone/widgets/cards.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController searchController;
  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "GameZone",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
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
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const CartPage(),
                    maintainState: false),
              );
            },
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.black,
              size: 25,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 8, left: 16, right: 16),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search the game...",
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.only(left: 8),
                  fillColor: const Color.fromRGBO(220, 220, 220, 1),
                  filled: true,
                ),
                onEditingComplete: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SearchPage(
                            text: searchController.text,
                          )));
                },
              ),
            ),
            const Divider(),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("userSellProduct")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Something wrong happens"),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                }
                final List listdata = [];
                snapshot.data!.docs.map((DocumentSnapshot documents) {
                  Map<String, dynamic> data =
                      documents.data() as Map<String, dynamic>;
                  listdata.add(data);
                }).toList();
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: listdata.length,
                  itemBuilder: (context, index) {
                    return Cards(
                      image: listdata[index]['productUrl'],
                      heading: listdata[index]['gameName'],
                      subHeading: listdata[index]['subTitle'],
                      price: "price - ${listdata[index]['demandedPrice']}\$",
                      productId: listdata[index]['postId'],
                      description: listdata[index]['description'],
                      likes: listdata[index]['likes'],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
