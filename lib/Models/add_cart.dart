class AddCart {
  final String uid;
  final String productId;
  final String username;
  final String email;
  final String name;
  final String gameName;
  final String demandedPrice;
  final String subTitle;
  final String gameEmail;
  final String gamePassword;
  final String description;
  final String phoneNumber;
  final String productUrl;
  final datepublished;

  AddCart(
      {required this.uid,
      required this.productId,
      required this.username,
      required this.email,
      required this.name,
      required this.gameName,
      required this.demandedPrice,
      required this.subTitle,
      required this.gameEmail,
      required this.gamePassword,
      required this.description,
      required this.phoneNumber,
      required this.productUrl,
      required this.datepublished});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'postId': productId,
      'username': username,
      'email': email,
      'name': name,
      'gameName': gameName,
      'demandedPrice': demandedPrice,
      'subTitle': subTitle,
      'gameEmail': gameEmail,
      'gamePassword': gamePassword,
      'description': description,
      'phoneNumber': phoneNumber,
      'productUrl': productUrl,
      'datepublished': datepublished,
    };
  }

  factory AddCart.fromMap(Map<String, dynamic> map) {
    return AddCart(
      uid: map['uid'] ?? '',
      productId: map['postId'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      gameName: map['gameName'] ?? '',
      demandedPrice: map['demandedPrice'] ?? '',
      subTitle: map['subTitle'] ?? '',
      gameEmail: map['gameEmail'] ?? '',
      gamePassword: map['gamePassword'] ?? '',
      description: map['description'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      productUrl: map['productUrl'] ?? '',
      datepublished: map['datePublished'] ?? '',
    );
  }
}
