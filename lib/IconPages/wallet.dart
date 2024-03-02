import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamezone/Dialogs/show_error_dialog.dart';
import 'package:gamezone/Models/wallet_data.dart';
import 'package:gamezone/constants/routes.dart';

class GameWallet extends StatefulWidget {
  const GameWallet({super.key});

  @override
  State<GameWallet> createState() => _GameWalletState();
}

class _GameWalletState extends State<GameWallet> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context).size;
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
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "Game Wallet",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "Create your GameZone Wallet",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Step 2/2"),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "1. Kindly Read the Business Plan.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "2. Here we are creating GameZone wallet. Any selling-buying process money will come under this wallet",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "3. You can Cash-In the money any time your want buy linking your bank account and submitting other documents",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "4. You can directly create Wallet and link account later or link it first and create wallet",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              width: query.width,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                color: Colors.blue,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 2,
                    spreadRadius: -1.5,
                  )
                ],
              ),
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "Link Bank Account",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("OR"),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              width: query.width,
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
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  final navigator = Navigator.of(context);
                  try {
                    setState(() {
                      isLoading = true;
                    });
                    int totalPrice = 0;
                    var collection =
                        FirebaseFirestore.instance.collection('soldproduct');
                    var querySnapshot = await collection.get();
                    for (var doc in querySnapshot.docs) {
                      Map<String, dynamic> data = doc.data();
                      totalPrice += int.parse(data['demandedPrice']);
                    }
                    DocumentSnapshot snap = await FirebaseFirestore.instance
                        .collection("users")
                        .doc(user!.uid)
                        .collection("currentUserData")
                        .doc(user.uid)
                        .get();
                    Map<String, dynamic> data =
                        snap.data() as Map<String, dynamic>;

                    final walletdata = WalletData(
                      uid: data['uid'],
                      username: data['username'],
                      email: data['email'],
                      name: data['name'],
                      bio: data['bio'],
                      gender: data['gender'],
                      contact: data['contact'],
                      location: data['location'],
                      profileUrl: data['profileUrl'],
                      totalPrice: "$totalPrice",
                      datepublished: data['datepublished'],
                    );

                    await FirebaseFirestore.instance
                        .collection("wallets")
                        .doc(user.uid)
                        .set(
                          walletdata.toMap(),
                        );
                    setState(() {
                      isLoading = false;
                    });
                    navigator.pushNamed(walletProfilePageScreenRoute);
                  } catch (e) {
                    await showErrorDialog(context, e.toString());
                  }
                },
                child: isLoading == false
                    ? const Text(
                        "Create Wallet",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
