import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:gamezone/constants/routes.dart';

import 'package:gamezone/widgets/cards.dart';

class SellPage extends StatefulWidget {
  const SellPage({super.key});

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: query.width,
                height: 200,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 2,
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(
                      20,
                    ),
                  ),
                  color: Colors.purple,
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Hiii Imran!!! Your Welcome",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Your Can sell your Game Id here",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 10,
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    shadowColor: Colors.greenAccent,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                    minimumSize: const Size(100, 40),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Read Business Plan",
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(
                  16,
                ),
                margin: const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                width: MediaQuery.of(context).size.width,
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
                      "Join As a Seller",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                        "Before Joining as a seller kindly read our business plans."),
                    const SizedBox(
                      height: 10,
                    ),
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection("wallets")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasData && snapshot.data!.exists) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.yellow),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
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
                                Navigator.of(context).pushNamed(
                                  walletProfilePageScreenRoute,
                                );
                              },
                              child: const Text(
                                "Go To Account",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.yellow),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
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
                                Navigator.of(context).pushNamed(
                                  sellMainPageScreenRoute,
                                );
                              },
                              child: const Text(
                                "Create Seller Account",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(
                  10,
                ),
                child: Column(
                  children: [
                    const Text(
                      "Why Sell on GameZone?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.all(
                          16,
                        ),
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 20,
                        ),
                        width: MediaQuery.of(context).size.width,
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
                              Icons.payment_rounded,
                              size: 50,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Recieve Timely Payment",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                                "GameZone ensures your payments are deposited directly in your bank account within 7-14 days.")
                          ],
                        )),
                    Container(
                      padding: const EdgeInsets.all(
                        16,
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 20,
                      ),
                      width: MediaQuery.of(context).size.width,
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
                            Icons.delivery_dining_outlined,
                            size: 50,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Reach other customers",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                              "Sell to many other engaged customer visiting GameZone through our mobile app.")
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(
                        16,
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 20,
                      ),
                      width: MediaQuery.of(context).size.width,
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
                            Icons.money_outlined,
                            size: 50,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Earn more Money",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("You can earn while playing games")
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      "Our Products",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
                            price:
                                "price - ${listdata[index]['demandedPrice']}\$",
                            productId: listdata[index]['postId'],
                            description: listdata[index]['description'],
                            likes: listdata[index]['likes'],
                          );
                        },
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
