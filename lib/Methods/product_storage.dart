import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProductStorage {
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;

  Future<String> uploadProductToStorage(String bucketName, String secondBucket,
      Uint8List file, String postId) async {
    final reference = storage
        .ref()
        .child(bucketName)
        .child(secondBucket)
        .child(auth.currentUser!.uid)
        .child(postId);

    UploadTask uploadTask = reference.putData(file);

    TaskSnapshot snap = await uploadTask;
    final downloadUrl = snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadAdditionalProductPhotoToStorage(String bucketName,
      String secondBucket, Uint8List file, String postId) async {
    final reference =
        storage.ref().child(bucketName).child(secondBucket).child(postId);

    UploadTask uploadTask = reference.putData(file);

    TaskSnapshot snap = await uploadTask;
    final downloadUrl = snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadProfileToStorage(
      String bucketName, String secondBucket, Uint8List file) async {
    final reference = storage
        .ref()
        .child(bucketName)
        .child(secondBucket)
        .child(auth.currentUser!.uid);

    UploadTask uploadTask = reference.putData(file);

    TaskSnapshot snap = await uploadTask;
    final downloadUrl = snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
