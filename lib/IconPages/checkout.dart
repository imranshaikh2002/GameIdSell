import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamezone/Dialogs/show_error_dialog.dart';
import 'package:gamezone/Models/order.dart';
import 'package:gamezone/Models/sell_product.dart';
import 'package:uuid/uuid.dart';

class CheckOutPage extends StatefulWidget {
  final List data;
  const CheckOutPage({super.key, required this.data});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  var totalPrice = 0;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        title: const Text("Checkout"),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
        height: 170,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(
            25,
          )),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    final navigator = Navigator.of(context);
                    final List ids = [];
                    try {
                      setState(() {
                        loading = true;
                      });
                      final orderId = const Uuid().v1();
                      for (int i = 0; i < widget.data.length; i++) {
                        ids.add(widget.data[i]['uid']);
                        final productData = SellProduct(
                          uid: widget.data[i]['uid'],
                          productId: widget.data[i]['postId'],
                          username: widget.data[i]['username'],
                          email: widget.data[i]['email'],
                          name: widget.data[i]['name'],
                          gameName: widget.data[i]['gameName'],
                          demandedPrice: widget.data[i]['demandedPrice'],
                          subTitle: widget.data[i]['subTitle'],
                          gameEmail: widget.data[i]['gameEmail'],
                          gamePassword: widget.data[i]['gamePassword'],
                          description: widget.data[i]['description'],
                          phoneNumber: widget.data[i]['phoneNumber'],
                          productUrl: widget.data[i]['productUrl'],
                          likes: widget.data[i]['likes'],
                          datepublished: widget.data[i]['datepublished'],
                        );

                        await FirebaseFirestore.instance
                            .collection("orders")
                            .doc(user!.uid)
                            .collection("userOrder")
                            .doc(orderId)
                            .collection("products")
                            .doc(widget.data[i]['postId'])
                            .set(
                              productData.toMap(),
                            );
                        await FirebaseFirestore.instance
                            .collection("orders")
                            .doc(user.uid)
                            .collection("orderedProducts")
                            .doc(widget.data[i]['postId'])
                            .set(
                              productData.toMap(),
                            );
                        await FirebaseFirestore.instance
                            .collection("soldproduct")
                            .doc(widget.data[i]['postId'])
                            .set(
                              productData.toMap(),
                            );

                        await FirebaseFirestore.instance
                            .collection("userCart")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("currentUserCart")
                            .doc(widget.data[i]['postId'])
                            .delete();
                        await FirebaseFirestore.instance
                            .collection("userSellProduct")
                            .doc(widget.data[i]['postId'])
                            .delete();
                      }
                      DocumentSnapshot snap = await FirebaseFirestore.instance
                          .collection("users")
                          .doc(user!.uid)
                          .get();
                      Map<String, dynamic> userdata =
                          snap.data() as Map<String, dynamic>;

                      final orderData = OrderData(
                        uid: userdata['uid'],
                        orderId: orderId,
                        username: userdata['username'],
                        email: userdata['email'],
                        totalPrice: "$totalPrice",
                        datepublished: DateTime.now(),
                      );

                      await FirebaseFirestore.instance
                          .collection("orders")
                          .doc(user.uid)
                          .collection("userOrder")
                          .doc(orderId)
                          .set(
                            orderData.toMap(),
                          );

                      for (int i = 0; i < ids.length; i++) {
                        int total = 0;
                        var collection = FirebaseFirestore.instance
                            .collection('soldproduct')
                            .where('uid', isEqualTo: ids[i]);
                        var querySnapshot = await collection.get();
                        for (var doc in querySnapshot.docs) {
                          Map<String, dynamic> data = doc.data();
                          total += int.parse(data['demandedPrice']);
                        }

                        await FirebaseFirestore.instance
                            .collection("wallets")
                            .doc(ids[i])
                            .update({'totalPrice': total});
                      }
                      setState(() {
                        loading = false;
                      });
                      navigator.popUntil((route) => route.isFirst);
                    } catch (e) {
                      await showErrorDialog(context, e.toString());
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 6,
                    ),
                    width: MediaQuery.of(context).size.width / 3.5,
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
                    child: loading == false
                        ? const Column(
                            children: [
                              Icon(
                                Icons.payments_rounded,
                                size: 40,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Using",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Net Banking",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                        : const CircularProgressIndicator(),
                  ),
                ),
                GestureDetector(
                  onTap: () => {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 6,
                    ),
                    width: MediaQuery.of(context).size.width / 3.5,
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
                    child: const Column(
                      children: [
                        Icon(
                          Icons.payments_rounded,
                          size: 40,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            Text(
                              "Using",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "UPI",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 6,
                    ),
                    width: MediaQuery.of(context).size.width / 3.5,
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
                    child: const Column(
                      children: [
                        Icon(
                          Icons.payments_rounded,
                          size: 40,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            Text(
                              "Using",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Credit Card",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "Please Select Anyone Payment Option",
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(
            16,
          ),
          margin: const EdgeInsets.all(
            8,
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
              const Text(
                "Your Order",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(),
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection("userCart")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection("currentUserCart")
                    .get(),
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
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                            ),
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
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Price",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${listdata[index]['demandedPrice']}\$",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  );
                },
              ),
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection("userCart")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection("currentUserCart")
                    .get(),
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
                  int total = 0;
                  snapshot.data!.docs.map((DocumentSnapshot documents) {
                    Map<String, dynamic> data =
                        documents.data() as Map<String, dynamic>;
                    listdata.add(data);
                  }).toList();
                  for (var i = 0; i < listdata.length; i++) {
                    total += int.parse(listdata[i]['demandedPrice']);
                  }
                  totalPrice = total;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Total Price:-",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text("$totalPrice\$",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
