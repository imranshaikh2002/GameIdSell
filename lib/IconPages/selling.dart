import 'package:flutter/material.dart';
import 'package:gamezone/IconPages/sell_body.dart';

class SellingPage extends StatefulWidget {
  const SellingPage({super.key});

  @override
  State<SellingPage> createState() => _SellingPageState();
}

class _SellingPageState extends State<SellingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
          "Your Wallet",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            SellBody(),
          ],
        ),
      ),
    );
  }
}
