import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamezone/IconPages/cart_page.dart';
import 'package:gamezone/constants/routes.dart';
import 'package:gamezone/widgets/profile_views.dart';

class WalletProfile extends StatefulWidget {
  const WalletProfile({super.key});

  @override
  State<WalletProfile> createState() => _WalletProfileState();
}

class _WalletProfileState extends State<WalletProfile> {
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
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "Your Wallet",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("wallets")
              .doc(FirebaseAuth.instance.currentUser!.uid)
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
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(
                      24,
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: MediaQuery.of(context).size.width / 5,
                    ),
                    width: 200,
                    height: 200,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(200)),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 2,
                          spreadRadius: -1.5,
                          color: Colors.grey,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Current Earning",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${data['totalPrice']} Rs",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Name"),
                            Text(data['name']),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Username"),
                            Text(data['username']),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Email"),
                            Text(data['email']),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("contact"),
                            Text(data['contact']),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Gender"),
                            Text(data['gender']),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("bio"),
                            const SizedBox(
                              width: 105,
                            ),
                            Expanded(
                              child: Text(data['bio']),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      ProfileButtons(
                        text: const Text("Sell Product"),
                        icon: const Icon(Icons.sell_sharp),
                        func: () => {
                          Navigator.of(context)
                              .pushNamed(sellingPageScreenRoute),
                        },
                      ),
                      ProfileButtons(
                        text: const Text("Your Cart"),
                        icon: const Icon(Icons.shopping_cart_outlined),
                        func: () => {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const CartPage(),
                            ),
                          )
                        },
                      ),
                      ProfileButtons(
                        text: const Text("Your Order"),
                        icon: const Icon(
                            Icons.playlist_add_check_circle_outlined),
                        func: () => {
                          Navigator.of(context).pushNamed(orderPageScreenRoute),
                        },
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}
