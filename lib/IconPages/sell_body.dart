import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamezone/Dialogs/show_error_dialog.dart';
import 'package:gamezone/Methods/product_storage.dart';
import 'package:gamezone/Models/sell_product.dart';
import 'package:gamezone/utilities/image_picker.dart';
import 'package:gamezone/widgets/textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../constants/routes.dart';

class SellBody extends StatefulWidget {
  const SellBody({super.key});

  @override
  State<SellBody> createState() => _SellBodyState();
}

class _SellBodyState extends State<SellBody> {
  late final TextEditingController _nameController;
  late final TextEditingController _gameController;
  late final TextEditingController _priceController;
  late final TextEditingController _oneLinerController;
  late final TextEditingController _gameEmailController;
  late final TextEditingController _gamePasswordController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _contactController;
  Uint8List? _file;
  bool loading = false;

  @override
  void initState() {
    _nameController = TextEditingController();
    _gameController = TextEditingController();
    _priceController = TextEditingController();
    _oneLinerController = TextEditingController();
    _gameEmailController = TextEditingController();
    _gamePasswordController = TextEditingController();
    _descriptionController = TextEditingController();
    _contactController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _gameController.dispose();
    _priceController.dispose();
    _oneLinerController.dispose();
    _gameEmailController.dispose();
    _gamePasswordController.dispose();
    _descriptionController.dispose();
    _contactController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context).size;
    return Column(
      children: [
        const Text(
          "Sell your Id",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  _file == null
                      ? Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 2,
                                spreadRadius: -1.5,
                              )
                            ],
                          ),
                          width: query.width,
                          child: const ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                10,
                              ),
                            ),
                            child: Image(
                              fit: BoxFit.fill,
                              image: AssetImage("assets/images/user.jpg"),
                              height: 300,
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 2,
                                spreadRadius: -1.5,
                              )
                            ],
                          ),
                          width: query.width,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(
                                10,
                              ),
                            ),
                            child: Image(
                              fit: BoxFit.fill,
                              image: MemoryImage(_file!),
                              height: 300,
                            ),
                          ),
                        ),
                  Positioned(
                    bottom: -2,
                    left: 0,
                    child: IconButton(
                      onPressed: () {
                        selectImageFromDialog(context);
                      },
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SellerDetailTextField(
                controller: _nameController,
                hintText: "Enter your legal name",
                secureText: false,
                keyboard: TextInputType.text,
              ),
              SellerDetailTextField(
                controller: _gameController,
                hintText: "Enter your game name",
                secureText: false,
                keyboard: TextInputType.text,
              ),
              SellerDetailTextField(
                controller: _priceController,
                hintText: "cost of your Id",
                secureText: false,
                keyboard: TextInputType.number,
              ),
              SellerDetailTextField(
                controller: _oneLinerController,
                hintText: "one line about your gameing Id",
                secureText: false,
                keyboard: TextInputType.text,
              ),
              SellerDetailTextField(
                controller: _gameEmailController,
                hintText: "Enter your game email Id",
                secureText: false,
                keyboard: TextInputType.emailAddress,
              ),
              SellerDetailTextField(
                controller: _gamePasswordController,
                hintText: "Enter your game password Id",
                secureText: true,
                keyboard: TextInputType.text,
              ),
              SellerDetailTextField(
                controller: _descriptionController,
                hintText: "Description about your game",
                secureText: false,
                keyboard: TextInputType.text,
              ),
              SellerDetailTextField(
                controller: _contactController,
                hintText: "Contact Number",
                secureText: false,
                keyboard: TextInputType.number,
              ),
            ],
          ),
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
              final name = _nameController.text;
              final gameName = _gameController.text;
              final price = _priceController.text;
              final subTitle = _oneLinerController.text;
              final gameEmail = _gameEmailController.text;
              final gamePassword = _gamePasswordController.text;
              final description = _descriptionController.text;
              final contact = _contactController.text;
              final user = FirebaseAuth.instance.currentUser;
              final navigator = Navigator.of(context);

              try {
                setState(() {
                  loading = true;
                });
                final productId = const Uuid().v1();
                String postUrl = await ProductStorage().uploadProductToStorage(
                  "userSellProduct",
                  "images",
                  _file!,
                  productId,
                );
                DocumentSnapshot snap = await FirebaseFirestore.instance
                    .collection("users")
                    .doc(user!.uid)
                    .get();
                Map<String, dynamic> data = snap.data() as Map<String, dynamic>;

                final productData = SellProduct(
                  uid: user.uid,
                  productId: productId,
                  username: data['username'],
                  email: data['email'],
                  name: name,
                  gameName: gameName,
                  demandedPrice: price,
                  subTitle: subTitle,
                  gameEmail: gameEmail,
                  gamePassword: gamePassword,
                  description: description,
                  phoneNumber: contact,
                  productUrl: postUrl,
                  likes: [],
                  datepublished: DateTime.now(),
                );

                await FirebaseFirestore.instance
                    .collection("userSellProduct")
                    .doc(productId)
                    .set(
                      productData.toMap(),
                    );
                await FirebaseFirestore.instance
                    .collection("userLiveSell")
                    .doc(user.uid)
                    .collection("products")
                    .doc(productId)
                    .set(
                      productData.toMap(),
                    );
                setState(() {
                  loading = false;
                });
                navigator.pushNamed(onSellPageScreenRoute);
              } catch (e) {
                await showErrorDialog(context, e.toString());
              }
            },
            child: loading == false
                ? const Text(
                    "Sell",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  )
                : const CircularProgressIndicator(),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(),
      ],
    );
  }
}
