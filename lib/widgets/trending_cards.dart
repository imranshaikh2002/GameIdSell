import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamezone/Dialogs/show_error_dialog.dart';
import 'package:gamezone/Models/sell_product.dart';
import 'package:gamezone/ProductDetails/product_page.dart';

class TrendingCards extends StatefulWidget {
  const TrendingCards({
    super.key,
  });

  @override
  State<TrendingCards> createState() => _TrendingCardsState();
}

class _TrendingCardsState extends State<TrendingCards> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("userSellProduct")
            .orderBy(
              'likes',
              descending: true,
            )
            .limit(3)
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
          snapshot.data!.docs.map(
            (document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              listdata.add(data);
            },
          ).toList();

          return ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: listdata.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProductPage(
                        image: listdata[index]['productUrl'],
                        heading: listdata[index]['gameName'],
                        subHeading: listdata[index]['subTitle'],
                        price: listdata[index]['demandedPrice'],
                        description: listdata[index]['description'],
                        productId: listdata[index]['postId'],
                        likes: listdata[index]['likes'],
                      ),
                    ),
                  ),
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 4, bottom: 2),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 6,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 2,
                        spreadRadius: -1.5,
                        color: Colors.grey,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  10,
                                ),
                              ),
                              child: Image(
                                image: NetworkImage(
                                  listdata[index]['productUrl'],
                                ),
                                fit: BoxFit.cover,
                                height: 60,
                                width: 60,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      listdata[index]['gameName'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      listdata[index]['subTitle'],
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                    onPressed: () async {
                                      final ref = listdata[index]['likes'];
                                      final user =
                                          FirebaseAuth.instance.currentUser;
                                      try {
                                        if (ref.contains(user!.uid)) {
                                          await FirebaseFirestore.instance
                                              .collection("userSellProduct")
                                              .doc(listdata[index]['postId'])
                                              .update(
                                            {
                                              'likes': FieldValue.arrayRemove(
                                                [user.uid],
                                              )
                                            },
                                          );
                                          await FirebaseFirestore.instance
                                              .collection("userLiveSell")
                                              .doc(user.uid)
                                              .collection("products")
                                              .doc(listdata[index]['postId'])
                                              .update(
                                            {
                                              'likes': FieldValue.arrayRemove(
                                                [user.uid],
                                              )
                                            },
                                          );
                                        } else {
                                          await FirebaseFirestore.instance
                                              .collection("userSellProduct")
                                              .doc(listdata[index]['postId'])
                                              .update(
                                            {
                                              'likes': FieldValue.arrayUnion(
                                                [user.uid],
                                              )
                                            },
                                          );
                                          await FirebaseFirestore.instance
                                              .collection("userLiveSell")
                                              .doc(user.uid)
                                              .collection("products")
                                              .doc(listdata[index]['postId'])
                                              .update(
                                            {
                                              'likes': FieldValue.arrayUnion(
                                                [user.uid],
                                              )
                                            },
                                          );
                                        }
                                      } catch (e) {
                                        showErrorDialog(
                                          context,
                                          e.toString(),
                                        );
                                      }
                                    },
                                    icon: listdata[index]['likes'].contains(
                                            FirebaseAuth
                                                .instance.currentUser!.uid)
                                        ? const Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          )
                                        : const Icon(Icons.favorite_border)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Price: ${listdata[index]['demandedPrice']}\$",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shadowColor: Colors.greenAccent,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                                minimumSize: const Size(80, 25),
                              ),
                              onPressed: () async {
                                final user = FirebaseAuth.instance.currentUser;

                                try {
                                  final productData = SellProduct(
                                    uid: listdata[index]['uid'],
                                    productId: listdata[index]['postId'],
                                    username: listdata[index]['username'],
                                    email: listdata[index]['email'],
                                    name: listdata[index]['name'],
                                    gameName: listdata[index]['gameName'],
                                    demandedPrice: listdata[index]
                                        ['demandedPrice'],
                                    subTitle: listdata[index]['subTitle'],
                                    gameEmail: listdata[index]['gameEmail'],
                                    gamePassword: listdata[index]
                                        ['gamePassword'],
                                    description: listdata[index]['description'],
                                    phoneNumber: listdata[index]['phoneNumber'],
                                    productUrl: listdata[index]['productUrl'],
                                    likes: [],
                                    datepublished: DateTime.now(),
                                  );

                                  await FirebaseFirestore.instance
                                      .collection("userCart")
                                      .doc(user!.uid)
                                      .collection("currentUserCart")
                                      .doc(listdata[index]['postId'])
                                      .set(
                                        productData.toMap(),
                                      );
                                } catch (e) {
                                  await showErrorDialog(context, e.toString());
                                }
                              },
                              child: FutureBuilder<DocumentSnapshot>(
                                  future: FirebaseFirestore.instance
                                      .collection('userCart')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .collection("currentUserCart")
                                      .doc(listdata[index]['postId'])
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    }
                                    if (snapshot.hasData &&
                                        snapshot.data!.exists) {
                                      return const Text(
                                        "Added",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    } else {
                                      return const Text(
                                        "Add to cart",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }
                                  }),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${listdata[index]['likes'].length} people upvote for this ID. So grab the deal",
                          style: const TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
