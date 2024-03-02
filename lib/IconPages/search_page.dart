import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gamezone/widgets/cards.dart';

class SearchPage extends StatefulWidget {
  final String text;
  const SearchPage({super.key, required this.text});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        toolbarHeight: 60,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Seaching for ${widget.text}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("userSellProduct")
            .where(
              'gameName',
              isGreaterThanOrEqualTo: widget.text,
            )
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Text("Noting found");
          }
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          final List listdata = [];
          snapshot.data!.docs.map(
            (document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              listdata.add(data);
            },
          ).toList();
          return ListView.builder(
            itemCount: listdata.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
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
    );
  }
}
