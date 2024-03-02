class UserData {
  final String uid;
  final String username;
  final String email;
  final String name;
  final String bio;
  final String gender;
  final String contact;
  final String location;
  final String profileUrl;
  final datepublished;

  UserData({
    required this.uid,
    required this.username,
    required this.email,
    required this.name,
    required this.bio,
    required this.gender,
    required this.contact,
    required this.location,
    required this.profileUrl,
    required this.datepublished,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'name': name,
      'bio': bio,
      'gender': gender,
      'contact': contact,
      'location': location,
      'profileUrl': profileUrl,
      'datepublished': datepublished,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      bio: map['bio'] ?? '',
      gender: map['gender'] ?? '',
      contact: map['contact'] ?? '',
      location: map['location'] ?? '',
      profileUrl: map['profileUrl'] ?? '',
      datepublished: map['datePublished'] ?? '',
    );
  }
}
