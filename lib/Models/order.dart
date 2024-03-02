class OrderData {
  final String uid;
  final String orderId;
  final String username;
  final String email;
  final String totalPrice;
  final datepublished;

  OrderData({
    required this.uid,
    required this.orderId,
    required this.username,
    required this.email,
    required this.totalPrice,
    required this.datepublished,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'orderId': orderId,
      'username': username,
      'email': email,
      'totalPrice': totalPrice,
      'datepublished': datepublished,
    };
  }

  factory OrderData.fromMap(Map<String, dynamic> map) {
    return OrderData(
      uid: map['uid'] ?? '',
      orderId: map['orderId'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      totalPrice: map['totalPrice'] ?? '',
      datepublished: map['datePublished'] ?? '',
    );
  }
}
