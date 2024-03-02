class ContactDetail {
  final String uid;
  final String queryId;
  final String username;
  final String email;
  final String name;
  final String topic;
  final String message;
  final datePublished;

  ContactDetail({
    required this.uid,
    required this.queryId,
    required this.username,
    required this.email,
    required this.name,
    required this.topic,
    required this.message,
    required this.datePublished,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'queryId': queryId,
      'username': username,
      'email': email,
      'name': name,
      'topic': topic,
      'message': message,
      'datePublished': datePublished,
    };
  }

  factory ContactDetail.fromMap(Map<String, dynamic> map) {
    return ContactDetail(
      uid: map['uid'] ?? '',
      queryId: map['queryId'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      topic: map['topic'] ?? '',
      message: map['message'] ?? '',
      datePublished: map['datePublished'] ?? '',
    );
  }
}
