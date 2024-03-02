import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamezone/Dialogs/show_error_dialog.dart';
import 'package:gamezone/Methods/product_storage.dart';
import 'package:gamezone/Models/user_data.dart';
import 'package:gamezone/constants/routes.dart';
import 'package:gamezone/utilities/image_picker.dart';
import 'package:gamezone/widgets/textfield.dart';
import 'package:image_picker/image_picker.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  late final TextEditingController _locationController;
  late final TextEditingController _phoneNumberController;
  Uint8List? _file;
  bool isLoading = false;

  @override
  void initState() {
    _nameController = TextEditingController();
    _bioController = TextEditingController();
    _locationController = TextEditingController();
    _phoneNumberController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _phoneNumberController.dispose();

    super.dispose();
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  selectImageFromDialog(BuildContext context) {
    Uint8List file;
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Select an option"),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Click a photo"),
              onPressed: () async {
                Navigator.of(context).pop();
                file = await selectImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("select from gallery"),
              onPressed: () async {
                Navigator.of(context).pop();
                file = await selectImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String? gender = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text("Step 1/2"),
          const SizedBox(
            height: 10,
          ),
          Column(
            children: [
              Stack(
                children: [
                  _file == null
                      ? const CircleAvatar(
                          radius: 64,
                          backgroundImage: AssetImage("assets/images/user.jpg"),
                        )
                      : CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_file!),
                        ),
                ],
              ),
              TextButton(
                  onPressed: () async {
                    selectImageFromDialog(context);
                  },
                  child: const Text(
                    "Add Photo",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                      color: Colors.redAccent,
                    ),
                  ))
            ],
          ),
          Column(
            children: [
              const Text(
                "Make sure to fill all fields before adding the profile",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
              SellerDetailTextField(
                controller: _nameController,
                hintText: "Enter your Name",
                secureText: false,
                keyboard: TextInputType.text,
              ),
              const SizedBox(height: 10),
              SellerDetailTextField(
                controller: _bioController,
                hintText: "Enter your bio",
                secureText: false,
                keyboard: TextInputType.text,
              ),
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(95, 164, 154, 154),
                      blurRadius: 1,
                      spreadRadius: 1,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Gender"),
                    DropdownButton(
                      isExpanded: true,
                      elevation: 20,
                      dropdownColor: const Color.fromARGB(255, 245, 244, 242),
                      underline: null,
                      hint: const Text("Select Gender"),
                      value: gender != "" ? gender : "select Gender",
                      onChanged: (newValue) {
                        setState(() {
                          gender = newValue;
                        });
                      },
                      items: ["select Gender", "Male", "Female", "Other"]
                          .map((location) {
                        return DropdownMenuItem(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SellerDetailTextField(
                controller: _phoneNumberController,
                hintText: "Enter your Phone Number",
                secureText: false,
                keyboard: TextInputType.number,
              ),
              const SizedBox(height: 10),
              SellerDetailTextField(
                controller: _locationController,
                hintText: "Enter your Location",
                secureText: false,
                keyboard: TextInputType.text,
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2,
                      spreadRadius: -1.5,
                    )
                  ],
                ),
                child: TextButton(
                  onPressed: () async {
                    final name = _nameController.text;
                    final bio = _bioController.text;
                    final contact = _phoneNumberController.text;
                    final location = _locationController.text;
                    final navigator = Navigator.of(context);
                    final user = FirebaseAuth.instance.currentUser;
                    try {
                      setState(() {
                        isLoading = true;
                      });
                      String profileUrl =
                          await ProductStorage().uploadProfileToStorage(
                        "userProfile",
                        "images",
                        _file!,
                      );
                      DocumentSnapshot snap = await FirebaseFirestore.instance
                          .collection("users")
                          .doc(user!.uid)
                          .get();
                      Map<String, dynamic> data =
                          snap.data() as Map<String, dynamic>;

                      final userData = UserData(
                        uid: user.uid,
                        username: data['username'],
                        email: data['email'],
                        name: name,
                        bio: bio,
                        gender: gender!,
                        contact: contact,
                        location: location,
                        profileUrl: profileUrl,
                        datepublished: DateTime.now(),
                      );

                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(user.uid)
                          .collection("currentUserData")
                          .doc(user.uid)
                          .set(
                            userData.toMap(),
                          );
                      await FirebaseFirestore.instance
                          .collection("wallets")
                          .doc(user.uid)
                          .collection("profile")
                          .doc(user.uid)
                          .set(
                            userData.toMap(),
                          );
                      setState(() {
                        clearImage();
                        _nameController.text = "";
                        _bioController.text = "";
                        gender = "";
                        _phoneNumberController.text = "";
                        _locationController.text = "";
                        isLoading = false;
                      });

                      navigator.pushNamed(gameWalletPageScreenRoute);
                    } catch (e) {
                      await showErrorDialog(context, e.toString());
                    }
                  },
                  child: const Text(
                    "Next",
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
        ],
      ),
    );
  }
}
