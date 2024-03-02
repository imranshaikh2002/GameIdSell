import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamezone/IconPages/checkout.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    super.key,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List data = [];
  int sum = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "Cart",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("userCart")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("currentUserCart")
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
                      return GestureDetector(
                        onTap: () => {},
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 4, bottom: 4),
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
                          child: Row(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                      children: [
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Price - ${listdata[index]['demandedPrice']}\$",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                  width: 1,
                                                  color: Colors.black,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        32.0)),
                                            minimumSize: const Size(80, 25),
                                          ),
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection("userCart")
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .collection("currentUserCart")
                                                .doc(listdata[index]['postId'])
                                                .delete();
                                          },
                                          child: const Text(
                                            "remove",
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
            const Divider(),
            Container(
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
                    "Order Summary",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("userCart")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("currentUserCart")
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
                      data = listdata;
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                              )
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
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
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CheckOutPage(
                        data: data,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Proceed to Checkout",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
