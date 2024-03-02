import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamezone/IconPages/wallet.dart';
import 'package:gamezone/ProfilePages/user_profile.dart';

class SellMain extends StatefulWidget {
  const SellMain({super.key});

  @override
  State<SellMain> createState() => _SellMainState();
}

class _SellMainState extends State<SellMain> {
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
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "Hey Imran, Go for it",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
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
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection("wallets")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("profile")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.exists) {
                        return const GameWallet();
                      } else {
                        return const UserProfilePage();
                      }
                    },
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
