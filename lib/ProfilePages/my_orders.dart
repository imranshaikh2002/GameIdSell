import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({super.key});

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        title: const Text(
          "My Orders",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("orderedProducts")
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
              return Column(
                children: [
                  const SizedBox(
                    height: 15,
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
                        Text(
                          DateFormat.yMMMd().format(
                            listdata[index]['datepublished'].toDate(),
                          ),
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 32,
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
                                              fontSize: 20,
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
                                      Text(
                                        "Price - ${listdata[index]['demandedPrice']}\$",
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      Text(listdata[index]['description']),
                                    ],
                                  ),
                                ),
                                const Divider(),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: [
                            const Text(
                              "Your Credential",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Email - ${listdata[index]['gameEmail']}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Password - ${listdata[index]['gamePassword']}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                        const Text(
                          "Congratulation, Enjoy the game and shop again",
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
