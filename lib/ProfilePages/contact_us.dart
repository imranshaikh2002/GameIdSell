import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamezone/Dialogs/show_error_dialog.dart';
import 'package:gamezone/Models/contact_model.dart';
import 'package:gamezone/widgets/textfield.dart';
import 'package:uuid/uuid.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _topicController;
  late final TextEditingController _messageController;
  bool isLoading = false;

  @override
  void initState() {
    _nameController = TextEditingController();
    _topicController = TextEditingController();
    _messageController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _topicController.dispose();
    _messageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(25),
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
            backgroundColor: Colors.white,
            foregroundColor: Colors.white,
            toolbarHeight: 60,
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Contact us",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  "Call us or send a message and we'll reach you as soon as possible",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 10),
                SellerDetailTextField(
                  controller: _nameController,
                  hintText: "Enter your Name",
                  secureText: false,
                  keyboard: TextInputType.text,
                ),
                SellerDetailTextField(
                  controller: _topicController,
                  hintText: "Enter your Topic",
                  secureText: false,
                  keyboard: TextInputType.text,
                ),
                SellerDetailTextField(
                  controller: _messageController,
                  hintText: "Enter your Message",
                  secureText: false,
                  keyboard: TextInputType.text,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    final name = _nameController.text;
                    final topic = _topicController.text;
                    final message = _messageController.text;
                    final user = FirebaseAuth.instance.currentUser;

                    try {
                      setState(() {
                        isLoading = true;
                      });
                      final queryId = const Uuid().v1();
                      DocumentSnapshot snap = await FirebaseFirestore.instance
                          .collection("users")
                          .doc(user!.uid)
                          .get();
                      Map<String, dynamic> data =
                          snap.data() as Map<String, dynamic>;
                      final contactUsData = ContactDetail(
                        uid: user.uid,
                        queryId: queryId,
                        username: data['username'],
                        email: data['email'],
                        name: name,
                        topic: topic,
                        message: message,
                        datePublished: DateTime.now(),
                      );

                      await FirebaseFirestore.instance
                          .collection("userQueries")
                          .doc(queryId)
                          .set(
                            contactUsData.toMap(),
                          );
                      setState(() {
                        isLoading = false;
                      });

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      showErrorDialog(context, e.toString());
                    }
                  },
                  child: const Text("Send"),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.maps_home_work_outlined,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 10),
                      Flexible(
                          child: Text(
                        "Location",
                        style: TextStyle(
                            color: Color.fromARGB(255, 99, 95, 95),
                            fontSize: 12,
                            letterSpacing: 0.7),
                      ))
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.phone_callback_outlined,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 10),
                      Flexible(
                          child: Text(
                        "9322717614",
                        style: TextStyle(
                            color: Color.fromARGB(255, 99, 95, 95),
                            fontSize: 12,
                            letterSpacing: 0.7),
                      ))
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.mail_outline_rounded,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 10),
                      Flexible(
                          child: Text(
                        "27imranshaikh05@gmail.com",
                        style: TextStyle(
                            color: Color.fromARGB(255, 99, 95, 95),
                            fontSize: 12,
                            letterSpacing: 0.7),
                      ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isLoading)
          const Opacity(
            opacity: 0.8,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
