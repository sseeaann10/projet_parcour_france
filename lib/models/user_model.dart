class User {
  final String id;
  final String email;
  String username;
  String? photoUrl;
  String? bio;

  User({
    required this.id,
    required this.email,
    required this.username,
    this.photoUrl,
    this.bio,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      photoUrl: map['photoUrl'],
      bio: map['bio'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'photoUrl': photoUrl,
      'bio': bio,
    };
  }
}
