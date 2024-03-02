class Comment {
  final String uid;
  final String productId;
  final String commentId;
  final String email;
  final String username;
  final String comment;
  final datepublished;

  Comment({
    required this.uid,
    required this.productId,
    required this.commentId,
    required this.email,
    required this.username,
    required this.comment,
    required this.datepublished,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'productId': productId,
      'commentId': commentId,
      'email': email,
      'username': username,
      'comment': comment,
      'datepublished': datepublished,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      uid: map['uid'] ?? '',
      productId: map['productId'] ?? '',
      commentId: map['commentId'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      comment: map['comment'] ?? '',
      datepublished: map['datePublished'] ?? '',
    );
  }
}
