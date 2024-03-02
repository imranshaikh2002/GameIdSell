import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamezone/Dialogs/show_error_dialog.dart';
import 'package:gamezone/Methods/product_storage.dart';
import 'package:gamezone/Models/sell_product.dart';
import 'package:gamezone/utilities/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class OnSellPage extends StatefulWidget {
  const OnSellPage({super.key});

  @override
  State<OnSellPage> createState() => _OnSellPageState();
}

class _OnSellPageState extends State<OnSellPage> {
  Uint8List? _file;
  bool loading = false;
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
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
          "On Sell",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("userLiveSell")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("products")
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
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  10,
                                ),
                              ),
                              child: Image(
                                image:
                                    NetworkImage(listdata[index]["productUrl"]),
                                fit: BoxFit.fill,
                                height: 160,
                                width: MediaQuery.of(context).size.width / 2,
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              listdata[index]["gameName"],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              listdata[index]["subTitle"],
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
                                              "Base Price",
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
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Column(
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Add Additional photos for better reach and upvote",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection("soldproduct")
                                    .doc(listdata[index]['postId'])
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  if (snapshot.hasData &&
                                      snapshot.data!.exists) {
                                    return Container();
                                  } else {
                                    return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shadowColor: Colors.greenAccent,
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0)),
                                        minimumSize: const Size(80, 40),
                                      ),
                                      onPressed: () async {
                                        selectImageFromDialog(context);
                                        if (_file != null) {
                                          try {
                                            setState(() {
                                              loading = true;
                                            });
                                            final productId = const Uuid().v1();
                                            String postUrl = await ProductStorage()
                                                .uploadAdditionalProductPhotoToStorage(
                                                    "AddtionalPhotos",
                                                    listdata[index]['postId'],
                                                    _file!,
                                                    productId);

                                            final addtionalPhoto =
                                                AdditionalPhoto(
                                              uid: listdata[index]['uid'],
                                              productId: listdata[index]
                                                  ['postId'],
                                              photoId: productId,
                                              productUrl: postUrl,
                                              datepublished: DateTime.now(),
                                            );

                                            await FirebaseFirestore.instance
                                                .collection("userSellProduct")
                                                .doc(listdata[index]['postId'])
                                                .collection("photos")
                                                .doc(productId)
                                                .set(
                                                  addtionalPhoto.toMap(),
                                                );
                                            await FirebaseFirestore.instance
                                                .collection("userLiveSell")
                                                .doc(listdata[index]['uid'])
                                                .collection("products")
                                                .doc(listdata[index]['postId'])
                                                .collection("photos")
                                                .doc(productId)
                                                .set(
                                                  addtionalPhoto.toMap(),
                                                );

                                            setState(() {
                                              loading = false;
                                            });
                                          } catch (e) {
                                            await showErrorDialog(
                                                context, e.toString());
                                          }
                                        }
                                      },
                                      child: loading == false
                                          ? const Text(
                                              "Add Photo",
                                            )
                                          : const CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 10),
                            margin: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
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
                            child: FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection("soldproduct")
                                  .doc(listdata[index]['postId'])
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                if (snapshot.hasData && snapshot.data!.exists) {
                                  return const Text(
                                    "Sold",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else {
                                  return const Text(
                                    "Product on Sell",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                              },
                            ),
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
      ),
    );
  }
}
