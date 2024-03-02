import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamezone/Dialogs/show_error_dialog.dart';
import 'package:gamezone/Models/sell_product.dart';
import 'package:gamezone/ProductDetails/product_page.dart';

class Cards extends StatefulWidget {
  final String image;
  final String heading;
  final String subHeading;
  final String price;
  final String productId;
  final String description;
  final likes;
  const Cards(
      {super.key,
      required this.image,
      required this.heading,
      required this.subHeading,
      required this.price,
      required this.productId,
      required this.description,
      required this.likes});

  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductPage(
              image: widget.image,
              heading: widget.heading,
              subHeading: widget.subHeading,
              price: widget.price,
              description: widget.description,
              productId: widget.productId,
              likes: widget.likes,
            ),
          ),
        ),
      },
      child: Container(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
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
                          widget.image,
                        ),
                        fit: BoxFit.cover,
                        height: 60,
                        width: 60,
                      )),
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
                            widget.heading,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.subHeading,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                      IconButton(
                          onPressed: () async {
                            final ref = widget.likes;
                            final user = FirebaseAuth.instance.currentUser;
                            try {
                              if (ref.contains(user!.uid)) {
                                await FirebaseFirestore.instance
                                    .collection("userSellProduct")
                                    .doc(widget.productId)
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
                                    .doc(widget.productId)
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
                                    .doc(widget.productId)
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
                                    .doc(widget.productId)
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
                          icon: widget.likes.contains(
                                  FirebaseAuth.instance.currentUser!.uid)
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
                    widget.price,
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
                        DocumentSnapshot snap = await FirebaseFirestore.instance
                            .collection("userSellProduct")
                            .doc(widget.productId)
                            .get();
                        Map<String, dynamic> data =
                            snap.data() as Map<String, dynamic>;

                        final productData = SellProduct(
                          uid: data['uid'],
                          productId: data['postId'],
                          username: data['username'],
                          email: data['email'],
                          name: data['name'],
                          gameName: data['gameName'],
                          demandedPrice: data['demandedPrice'],
                          subTitle: data['subTitle'],
                          gameEmail: data['gameEmail'],
                          gamePassword: data['gamePassword'],
                          description: data['description'],
                          phoneNumber: data['phoneNumber'],
                          productUrl: data['productUrl'],
                          likes: [],
                          datepublished: DateTime.now(),
                        );

                        await FirebaseFirestore.instance
                            .collection("userCart")
                            .doc(user!.uid)
                            .collection("currentUserCart")
                            .doc(widget.productId)
                            .set(
                              productData.toMap(),
                            );

                        setState(() {});
                      } catch (e) {
                        await showErrorDialog(context, e.toString());
                      }
                    },
                    child: FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('userCart')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection("currentUserCart")
                          .doc(widget.productId)
                          .get(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const CircularProgressIndicator();
                          case ConnectionState.done:
                            if (snapshot.hasData && snapshot.data!.exists) {
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
                          default:
                            return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
