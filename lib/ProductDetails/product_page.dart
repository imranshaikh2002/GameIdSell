import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamezone/Dialogs/show_error_dialog.dart';
import 'package:gamezone/Models/comment_dart.dart';
import 'package:gamezone/Models/sell_product.dart';
import 'package:gamezone/widgets/cards.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductPage extends StatefulWidget {
  final String image;
  final String heading;
  final String subHeading;
  final String price;
  final String description;
  final String productId;
  final likes;
  const ProductPage({
    super.key,
    required this.image,
    required this.heading,
    required this.subHeading,
    required this.price,
    required this.description,
    required this.productId,
    required this.likes,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late final TextEditingController textController;

  @override
  void initState() {
    textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      bottomNavigationBar: GestureDetector(
        onTap: () async {
          final user = FirebaseAuth.instance.currentUser;

          try {
            DocumentSnapshot snap = await FirebaseFirestore.instance
                .collection("userSellProduct")
                .doc(widget.productId)
                .get();
            Map<String, dynamic> data = snap.data() as Map<String, dynamic>;

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
          } catch (e) {
            await showErrorDialog(context, e.toString());
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.yellow),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 2,
                spreadRadius: -1.5,
              )
            ],
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.shopping_cart_checkout_rounded,
                  ),
                ),
                const Text(
                  "Add to cart",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 2,
                      spreadRadius: -1.5,
                    )
                  ],
                ),
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  child: Image(
                    fit: BoxFit.fill,
                    image: NetworkImage(widget.image),
                    height: 300,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
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
                    icon: widget.likes
                            .contains(FirebaseAuth.instance.currentUser!.uid)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(Icons.favorite_border),
                  ),
                  const Text(
                    "Up-Vote",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 32,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.heading,
                              style: const TextStyle(
                                fontSize: 20,
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
                        Text(
                          widget.price,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(widget.description),
                      ],
                    ),
                  ),
                  const Divider(),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("userSellProduct")
                    .doc(widget.productId)
                    .collection("photos")
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
                  if (!snapshot.hasData) {
                    return const Text("Not Data");
                  }
                  final List normdata = [];
                  snapshot.data!.docs.map((DocumentSnapshot documents) {
                    Map<String, dynamic> data =
                        documents.data() as Map<String, dynamic>;
                    normdata.add(data);
                  }).toList();
                  return CarouselSlider.builder(
                    itemCount: normdata.length,
                    itemBuilder: (BuildContext context, index, int rand) {
                      return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Image.network(
                            normdata[index]['productUrl'],
                            fit: BoxFit.fill,
                          ));
                    },
                    options: CarouselOptions(
                      height: 200.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: false,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      viewportFraction: 0.8,
                    ),
                  );
                },
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(
                  16,
                ),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Review",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    const SizedBox(height: 15),
                    TextField(
                      controller: textController,
                      minLines: 4,
                      maxLines: 6,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        label: const Text("Comment"),
                        hintText: "Enter message",
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black26,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final comment = textController.text;
                        final user = FirebaseAuth.instance.currentUser;
                        try {
                          final commentId = const Uuid().v1();
                          DocumentSnapshot snap = await FirebaseFirestore
                              .instance
                              .collection("users")
                              .doc(user!.uid)
                              .get();
                          Map<String, dynamic> data =
                              snap.data() as Map<String, dynamic>;

                          final comments = Comment(
                            uid: user.uid,
                            productId: widget.productId,
                            commentId: commentId,
                            email: data['email'],
                            username: data['username'],
                            comment: comment,
                            datepublished: DateTime.now(),
                          );

                          FirebaseFirestore.instance
                              .collection("userSellProduct")
                              .doc(widget.productId)
                              .collection("comments")
                              .doc(commentId)
                              .set(
                                comments.toMap(),
                              );
                          setState(() {
                            textController.text = "";
                          });
                        } catch (e) {
                          showErrorDialog(
                            context,
                            e.toString(),
                          );
                        }
                      },
                      child: const Text(
                        "POST",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("userSellProduct")
                            .doc(widget.productId)
                            .collection("comments")
                            .orderBy('datepublished', descending: true)
                            .limit(5)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text("Something wrong happens"),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text("Loading");
                          }
                          final List commentList = [];
                          snapshot.data!.docs.map(
                            (document) {
                              Map<String, dynamic> data =
                                  document.data() as Map<String, dynamic>;
                              commentList.add(data);
                            },
                          ).toList();

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: commentList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 10,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  commentList[index]
                                                      ['username'],
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Text(
                                          DateFormat.yMMMd().format(
                                            commentList[index]['datepublished']
                                                .toDate(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),
                                      child:
                                          Text(commentList[index]['comment']),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        })
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("userSellProduct")
                    .where('gameName', isNotEqualTo: widget.heading)
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
